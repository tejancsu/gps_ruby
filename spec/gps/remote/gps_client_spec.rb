require 'spec_helper'

describe Gps::Client do
  REQUEST_TYPES = Gps::Request::Types::ALL

  # These will eventually be in helper files
  def get_dummy_request_params(request_type)
    case request_type
    when Gps::Request::Types::CAPTURE, Gps::Request::Types::CANCEL, Gps::Request::Types::REFUND, Gps::Request::Types::PAYMENTS
      {
        :country_code => "DE",
        :payment_id => "12341234-1234-1234-1234-123412341234"
      }
    when Gps::Request::Types::CREATE_BILLING_RECORD
      {
        :country_code => "DE",
        :billing_record_request => 1,
        :consumer_id => 123
      }
    when Gps::Request::Types::GET_BILLING_RECORDS
      {
        :country_code => "DE",
        :consumer_id => 123,
        :billing_record_ids => [23, 234],
        :active_only => false
      }
    when Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
      {
        :payment_type => "paypal",
        :country_code => "DE"
      }
    when Gps::Request::Types::AUTHORIZE, Gps::Request::Types::GET_PAYMENT_TYPES
      { :country_code => "DE" }
    else
      {}
    end
  end

  def execute_dummy_expect_success(request_type, pass_nil_logger = false)
    request_params = get_dummy_request_params(request_type)
    execute_expect_success(request_type, request_params, pass_nil_logger)
  end

  def execute_dummy_expect_timeout(request_type)
    request_params = get_dummy_request_params(request_type)
    execute_expect_timeout(request_type, request_params)
  end

  def execute_dummy_expect_gps_fail(request_type)
    request_params = get_dummy_request_params(request_type)
    execute_expect_gps_fail(request_type, request_params)
  end

  def execute_expect_success(request_type, request_params, pass_nil_logger = false)
    execute_request(request_type, request_params, pass_nil_logger)
  end

  def execute_expect_timeout(request_type, request_params)
    request_params[:stubbed_response] = "TimeoutException"
    execute_request(request_type, request_params)
  end

  def execute_expect_gps_fail(request_type, request_params)
    request_params[:stubbed_response] = "GpsException"
    execute_request(request_type, request_params)
  end

  def execute_request(request_type, request_params, pass_nil_logger = false)
    logger = pass_nil_logger ? nil : get_gps_logger
    client = Gps::Client.new(get_gps_config, logger)
    client.execute(request_type, {}, request_params)
  end

  def get_gps_config
    Object.const_defined?('AppConfig') && !AppConfig.gps.nil? ? AppConfig.gps : Gps::Config.new
  end

  def get_gps_logger
    Object.const_defined?('GPS_CLIENT_LOGGER') ? GPS_CLIENT_LOGGER : nil
  end

  def check_response(request_type, response)
    case request_type
    when Gps::Request::Types::CREATE_BILLING_RECORD
      response.billing_record.should_not be_nil
    when Gps::Request::Types::GET_BILLING_RECORDS
      response.billing_records.should_not be_nil
    when Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
      response.payment_attributes.should_not be_nil
    when Gps::Request::Types::GET_PAYMENT_TYPES
      response.payment_types.should_not be_nil
    else
    end
  end

  context '#execute' do
    REQUEST_TYPES.each do |request_type|
      context "#{request_type.to_s}" do
        context "when passing the GPS_CLIENT_LOGGER" do
          it "succeeds and passes the response" do
            response = execute_dummy_expect_success(request_type)
            response.status.should == :succeeded
            response.success?.should be_true
            response.errors.should be_nil
            check_response(request_type, response)
          end
          it "times out and passes the response" do
            response = execute_dummy_expect_timeout(request_type)
            response.status.should == :failed
            response.success?.should be_false
            response.errors.should == ["Typhoeus Timeout"]
          end
          it "gps fails and passes the response" do
            response = execute_dummy_expect_gps_fail(request_type)
            response.status.should == :failed
            response.success?.should be_false
            response.errors.should == ["Error Response: 500"]
          end
        end

        context "when not passing a logger, logs to STDOUT" do
          it "succeeds and passes the response" do
            response = execute_dummy_expect_success(request_type, true)
            response.status.should == :succeeded
            response.success?.should be_true
            response.errors.should be_nil
            check_response(request_type, response)
          end
        end
      end
    end
  end
end
