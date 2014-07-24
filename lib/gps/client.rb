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

  def execute(request_type, params)
    @logger_id = UUIDTools::UUID.timestamp_create.to_s
    params.dottable! if params.respond_to?(:dottable!)
    @logger.info(@logger_id, "execute.start", params.to_hash)
    if Gps::Request::Types::ALL.include?(request_type)
      begin
        if Rails.env.test? && !params.respond_to?(:stubbed_response)
          params[:stubbed_response] = generic_stubbed_response(request_type, params)
        elsif Rails.env.test? && params.stubbed_response.nil?
          params.stubbed_response = generic_stubbed_response(request_type, params)
        end
        request = self.request_class(request_type).new(@config.host, params)
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
      if !request.stubbed_response.nil?
        @logger.info(@logger_id, "send_request.stubbed_response", {
          :stubbed_response => request.stubbed_response.inspect
        })
        if request.stubbed_response == "TimeoutException"
          raise TimeoutException.new "Typhoeus Timeout"
        elsif request.stubbed_response == "GpsException"
          raise GpsException.new "Error Response: 500"
        else
          typhoeus_response = request.stubbed_response
        end
      else
        typhoeus_response = send_typhoeus_request(typhoeus_request, request.type)
      end

      return :succeeded, typhoeus_response
    rescue TimeoutException, GpsException, StandardError => e
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

  def generic_stubbed_response(request_type, params)
    case request_type
    when Gps::Request::Types::CREATE_BILLING_RECORD
        { "type" => params[:type], # params.type will return Hash
          "id" => params.try(:id),
          "variant" => params.try(:variant),
          "billing_address" =>
            { "name" => params.try(:billing_address).try(:name),
              "state" => params.try(:billing_address).try(:state),
              "country_iso_code" => params.try(:billing_address).try(:country_iso_code),
              "city" => params.try(:billing_address).try(:city),
              "postal_code" => params.try(:billing_address).try(:postal_code),
              "address_line1" => params.try(:billing_address).try(:address_line1),
              "address_line2" => params.try(:billing_address).try(:address_line2),
              "district" => params.try(:billing_address).try(:district)
            },
          "purchaser" =>
            { "name" => params.try(:purchaser).try(:name),
              "id" => params.try(:purchaser).try(:id),
              "locale" => params.try(:purchaser).try(:locale),
              "email" => params.try(:purchaser).try(:email)
            },
          "payment_data" =>
            { "name" => params.try(:payment_data).try(:holder_name),
              "number" => params.try(:payment_data).try(:number),
              "cvv" => params.try(:payment_data).try(:cvv),
              "expiry_month" => params.try(:payment_data).try(:expiry_month),
              "expiry_year" => params.try(:payment_data).try(:expiry_year)
            },
          "token_data" =>
          [ {
              "token_store" => "ADYEN",
              "token_id" => "adyenRecurringId-123",
              "status" => "UPTODATE"
            },
            {
              "token_store" => "PCI-TOKENIZER",
              "token_id" => "9901900000000051111",
              "status" => "UPTODATE"
            } ],
          "created_at" => Time.now,
          "updated_at" => Time.now
      }.to_json
    when Gps::Request::Types::GET_BILLING_RECORDS
      {
        :billing_records => [stubbed_billing_record]
      }.to_json
    when Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
      {
        :payment_attributes => []
      }.to_json
    when Gps::Request::Types::GET_PAYMENT_TYPES
      {
        :payment_types => stubbed_payment_types
      }.to_json
    when Gps::Request::Types::COMPLETE_AUTH
      {}.to_json
    when Gps::Request::Types::AUTHORIZE
      {
        "links" => {
          "self" => {
            "href" => "http://payments-vip.xxx/{countryCode}/payments/{id}"
          },
          "capture" => {
            "href" => "http://payments-vip.xxx/{countryCode}/payments/{id}/capture",
            "method" => "POST",
            "type" => "application/json",
            "data" => {
            }
          }
        },
        "id" => params.try(:payment_details).try(:id),
        "database_id" => params.try(:payment_details).try(:database_id)
      }.to_json
    when Gps::Request::Types::CAPTURE, Gps::Request::Types::REFUND
      {}.to_json
    else
      {
        :generic_response => "response"
      }.to_json
    end
  end

  def stubbed_payment_types
    payment_types = [
      Gps::PaymentType.new('creditcard', 'visa'),
      Gps::PaymentType.new('paypal')
    ]
  end

  def stubbed_billing_record
    Gps::StubbedBillingRecord.new.billing_record
  end
end
