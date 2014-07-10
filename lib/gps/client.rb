class Gps::Client
  class TimeoutException < StandardError; end
  class GpsException < StandardError; end;

  def initialize(config, logger = nil)
    @logger = Gps::Logger.new(logger)
    @config = config
  end

  def request_class(request_type)
    ("Gps::Request::" + request_type.to_s.camelize + "Request").constantize
  end

  def response_class(request_type)
    ("Gps::Response::" + request_type.to_s.camelize + "Response").constantize
  end

  def execute(request_type, params, url_params = {})
    @logger_id = UUIDTools::UUID.timestamp_create.to_s
    @logger.info(@logger_id, "execute.start", params)
    if Gps::Request::Types::ALL.include?(request_type)
      begin
        if Rails.env.test? && !url_params.include?(:stubbed_response)
          url_params[:stubbed_response] = generic_stubbed_response(request_type).dottable!
        elsif return_stubbed_response?(request_type)
          url_params[:stubbed_response] = stubbed_response(request_type)
        end
        request = self.request_class(request_type).new(@config.host, params, url_params)
      rescue Gps::Request::ParamsErrorException, Gps::Request::TypeMissingException => e
        return self.response_class(request_type).new(:failed, e.message)
      end

      status, typhoeus_response = send_request(request, @config)

      @logger.info(@logger_id, "send_request.#{request_type}.finished", {
        :status => status, :typhoeus_response => typhoeus_response.inspect
      })
      return self.response_class(request_type).new(status, typhoeus_response)
    else
      @logger.error(@logger_id, "execute.#{request_type}.not_supported")
      status = :failed
      typhoeus_response = "GPS Request Type #{request_type} is not supported."
      return Gps::Response::Base.new(status, typhoeus_response)
    end

  end

  private

  def send_request(request, config)
    headers = config[request.type.to_s]['headers'] || {}
    # Sensible default
    if headers['Content-Type'].nil?
      headers['Content-Type'] = 'application/json'
    end

    read_timeout = config[request.type.to_s]['read_timeout']
    connect_timeout = config[request.type.to_s]['connect_timeout']

    body = request.body
    url = request.url

    options = {
      :method => request.http_method,
      :headers => headers,
      :read_timeout => read_timeout,
      :connect_timeout => connect_timeout,
      :body => body,
    }

    logger_info = request.logger_info

    typhoeus_request = Typhoeus::Request.new(url, options)

    @logger.info(@logger_id, "send_request.#{request.type}", logger_info)

    begin
      # For testing.
      if !request.params[:stubbed_response].nil?
        @logger.info(@logger_id, "send_request.stubbed_response", {
          :stubbed_response => request.params[:stubbed_response].inspect
        })
        if request.params[:stubbed_response] == "TimeoutException"
          raise TimeoutException.new "Typhoeus Timeout"
        elsif request.params[:stubbed_response] == "GpsException"
          raise GpsException.new "Error Response: 500"
        else
          typhoeus_response = request.params[:stubbed_response]
        end
      else
        typhoeus_response = send_typhoeus_request(typhoeus_request, request.type)
      end

      return :succeeded, typhoeus_response

    rescue TimeoutException, GpsException => e
      return :failed, e.message
    end
  end

  def send_typhoeus_request(typhoeus_request, request_type)
    begin
      hydra = Typhoeus::Hydra.new
      hydra.queue( typhoeus_request )
      hydra.run

      typhoeus_response = typhoeus_request.response

      request_benchmarks = extract_request_benchmarks(typhoeus_response)

      if typhoeus_response.timed_out?
        raise TimeoutException.new "Typhoeus Timeout"
      elsif !typhoeus_response.success? # success? checks (code >= 200 && code < 300)
        error = {
          :code => typhoeus_response.code
        }.merge(request_benchmarks)
        error[:body] = typhoeus_response.body if typhoeus_response.body.present?
        @logger.error(@logger_id, "send_typhoeus_request.response.#{request_type}.error", error)
        raise GpsException.new "Error Response: #{typhoeus_response.code}"
      else
        @logger.info(@logger_id, "send_typhoeus_request.response.#{request_type}.success", {
          :code => typhoeus_response.code,
          :body => typhoeus_response.body
        }.merge(request_benchmarks))
      end

      typhoeus_response = typhoeus_response.body
    rescue TimeoutException => e
      @logger.error(@logger_id, "send_typhoeus_request.#{request_type}.timeout", request_benchmarks)
      raise e
    end

    typhoeus_response
  end

  def extract_request_benchmarks(typhoeus_response)
    {
      :name_lookup_time => typhoeus_response.name_lookup_time,
      :connect_time => typhoeus_response.connect_time,
      :app_connect_time => typhoeus_response.app_connect_time,
      :start_transfer_time => typhoeus_response.start_transfer_time,
      :total_time => typhoeus_response.time
    }
  end

  ####################
  # For testing
  ####################

  # when specific parameters are passed in, automatically return success or failure
  def return_stubbed_response?(request_type)
    # TODO - figure out default succeed / fail values
    case request_type
    when Gps::Request::Types::CREATE_BILLING_RECORD
    when Gps::Request::Types::GET_BILLING_RECORDS
    when Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
    when Gps::Request::Types::GET_PAYMENT_TYPES
    else
    end

    return false # for now
  end

  def stubbed_response(request_type)
    # TODO - figure out default succeed / fail values for payments
    case request_type
    when Gps::Request::Types::CREATE_BILLING_RECORD
    when Gps::Request::Types::GET_BILLING_RECORDS
    when Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
    when Gps::Request::Types::GET_PAYMENT_TYPES
    else
    end
  end

  def generic_stubbed_response(request_type)
    case request_type
    when Gps::Request::Types::CREATE_BILLING_RECORD
      {
        :billing_record => stubbed_billing_record
      }
    when Gps::Request::Types::GET_BILLING_RECORDS
      {
        :billing_records => [stubbed_billing_record]
      }
    when Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
      {
        :payment_attributes => []
      }
    when Gps::Request::Types::GET_PAYMENT_TYPES
      {
        :payment_types => stubbed_payment_types
      }
    else
      {
        :generic_response => "response"
      }
    end
  end

  def stubbed_payment_types
    payment_types = [
      Gps::PaymentType.new('creditcard', 'visa'),
      Gps::PaymentType.new('paypal')
    ]
  end

  def stubbed_billing_record
    Gps::StubbedBillingRecord.new
  end
end
