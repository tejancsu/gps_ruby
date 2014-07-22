require 'spec_helper'

describe Gps::Client do
  REQUEST_TYPES = Gps::Request::Types::ALL

  # These will eventually be in helper files
  def get_dummy_request_params(request_type)
    case request_type
    when Gps::Request::Types::AUTHORIZE
      {
        :country_code => "DE",
        :payment_details => {
          :id => UUIDTools::UUID.random_create.to_s,
          :database_id => 12345,
          :payment_support_reference => "aoeuaoeu1",
          :billing_record => {
            :id => UUIDTools::UUID.random_create.to_s
          },
          :amount => {
            :value => 1234, # minor units
            :currency_code => "USD"
          },
          :application_base_url => "aoeuaoeuaoeu.com",
          :context => {
            :client_ip => "127.0.0.01",
            :origin_client_id => "iOS-client-id",
            :client_id => "orders-client_id",
            :accept_header => "header!!",
            :user_agent => "Mozilla/5.0"
          }
        },
        :settlement_details => {
          :version => "1.0",
          :items => [
            {
              :amount => {
                :value => 617,
                :currency_code => "USD"
              },
              :type => "GLOBAL_TRAVEL"
            }
          ]
        }
      }
    when Gps::Request::Types::CAPTURE
      {
        :country_code => "DE",
        :payment_id => UUIDTools::UUID.random_create.to_s,
        :capture_details => {
          :id => UUIDTools::UUID.random_create.to_s,
          :amount => {
            :value => 1234, # minor units
            :currency_code => "USD"
          }
        }
      }
    when Gps::Request::Types::REFUND
      {
        :country_code => "DE",
        :payment_id => UUIDTools::UUID.random_create.to_s,
        :refund_details => {
          :id => UUIDTools::UUID.random_create.to_s,
          :amount => {
            :value => 1234, # minor units
            :currency_code => "USD"
          },
        },
        :settlement_details => {
          :version => "1.0",
          :items => [
            {
              :amount => {
                :value => 617,
                :currency_code => "USD"
              },
              :type => "GLOBAL_TRAVEL"
            }
          ]
        }
      }
    when Gps::Request::Types::CANCEL, Gps::Request::Types::REFUND,
      Gps::Request::Types::COMPLETE_AUTH, Gps::Request::Types::SHOW_PAYMENT
      {
        :country_code => "DE",
        :payment_id => "12341234-1234-1234-1234-123412341234"
      }
    when Gps::Request::Types::CREATE_BILLING_RECORD
      {
        :id => UUIDTools::UUID.random_create.to_s,
        :type => 'creditcard',
        :variant => 'visa',
        :billing_address => { :postal_code      => '12345',
                              :country_iso_code => 'DE',
                              :state            => 'State',
                              :district         => 'District',
                              :city             => 'Town',
                              :address_line1    => 'Street 12',
                              :address_line2    => 'last House in the street',
                              :name             => 'Mr & Ms Muster' },
        :payment_data => {  :holder_name    => 'Max Muster',
                            :number         => '4242424242424242',
                            :cvv            => '1234',
                            :expiry_month   => '12',
                            :expiry_year    => '2017' },
        :purchaser => { :name           => ' Marianne Muster',
                        :email          =>  'marianne.muster@example.com',
                        :locale         =>  'de_DE',
                        :id             =>  UUIDTools::UUID.random_create.to_s }
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
    when Gps::Request::Types::GET_PAYMENT_TYPES
      { :country_code => "DE" }
    else
      {}
    end
  end

  def execute_dummy_expect_success(request_type, pass_nil_logger = false)
    request_params = get_dummy_request_params(request_type)
    return [request_params, execute_expect_success(request_type, request_params, pass_nil_logger)]
  end

  def execute_dummy_expect_timeout(request_type)
    request_params = get_dummy_request_params(request_type)
    return [request_params, execute_expect_timeout(request_type, request_params)]
  end

  def execute_dummy_expect_gps_fail(request_type)
    request_params = get_dummy_request_params(request_type)
    return [request_params, execute_expect_gps_fail(request_type, request_params)]
  end

  def execute_expect_success(request_type, request_params, pass_nil_logger = false)
    execute_request(request_type, request_params, pass_nil_logger)
  end

  def execute_expect_timeout(request_type, request_params)
    request_params.merge!({ :stubbed_response => "TimeoutException" })
    execute_request(request_type, request_params)
  end

  def execute_expect_gps_fail(request_type, request_params)
    request_params.merge!({ :stubbed_response => "GpsException" })
    execute_request(request_type, request_params)
  end

  def execute_request(request_type, request_params, pass_nil_logger = false)
    logger = pass_nil_logger ? nil : get_gps_logger
    client = Gps::Client.new(get_gps_config, logger)
    client.execute(request_type, request_params)
  end

  def get_gps_config
    Object.const_defined?('AppConfig') && !AppConfig.gps.nil? ? AppConfig.gps : Gps::Config.new
  end

  def get_gps_logger
    Object.const_defined?('GPS_CLIENT_LOGGER') ? GPS_CLIENT_LOGGER : nil
  end

  def check_response(request_type, request_params, response)
    case request_type
    when Gps::Request::Types::CREATE_BILLING_RECORD
      br = response.billing_record
      br["type"].should == request_params[:type]
      br["id"].should == request_params[:id].to_s
      br["variant"].should == request_params[:variant]
      br["created_at"].should be_present
      br["updated_at"].should be_present

      br["billingAddress"]["name"].should == request_params[:billing_address][:name]
      br["billingAddress"]["state"].should == request_params[:billing_address][:state]
      br["billingAddress"]["countryIsoCode"].should == request_params[:billing_address][:country_iso_code]
      br["billingAddress"]["city"].should == request_params[:billing_address][:city]
      br["billingAddress"]["postalCode"].should == request_params[:billing_address][:postal_code]
      br["billingAddress"]["addressLine1"].should == request_params[:billing_address][:address_line1]
      br["billingAddress"]["addressLine2"].should == request_params[:billing_address][:address_line2]
      br["billingAddress"]["district"].should == request_params[:billing_address][:district]

      br["purchaser"]["name"].should == request_params[:purchaser][:name]
      br["purchaser"]["id"].should == request_params[:purchaser][:id].to_s
      br["purchaser"]["locale"].should == request_params[:purchaser][:locale]
      br["purchaser"]["email"].should == request_params[:purchaser][:email]

      br["paymentData"]["name"].should == request_params[:payment_data][:holder_name]
      br["paymentData"]["number"].should == request_params[:payment_data][:number]
      br["paymentData"]["cvv"].should == request_params[:payment_data][:cvv]
      br["paymentData"]["expiryMonth"].should == request_params[:payment_data][:expiry_month]
      br["paymentData"]["expiryYear"].should == request_params[:payment_data][:expiry_year]

      br["tokenData"].should be_present
    when Gps::Request::Types::GET_BILLING_RECORDS
      response.billing_records.should_not be_nil
    when Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
      response.payment_attributes.should_not be_nil
    when Gps::Request::Types::GET_PAYMENT_TYPES
      response.payment_types.should_not be_nil
    when Gps::Request::Types::AUTHORIZE
      response.response["links"].should_not be_nil
      response.response["links"]["capture"].should_not be_nil
      response.response["id"].should == request_params[:payment_details][:id].to_s
      response.response["databaseId"].should == request_params[:payment_details][:database_id]
    else
    end
  end

  context '#execute' do
    REQUEST_TYPES.each do |request_type|
      context "#{request_type.to_s}" do
        context "when passing the GPS_CLIENT_LOGGER" do
          it "succeeds and passes the response" do
            params, response = execute_dummy_expect_success(request_type)
            response.status.should == :succeeded
            response.success?.should be_true
            response.errors.should be_nil
            check_response(request_type, params, response)
          end
          it "times out and passes the response" do
            params, response = execute_dummy_expect_timeout(request_type)
            response.status.should == :failed
            response.success?.should be_false
            response.errors.should == ["Typhoeus Timeout"]
          end
          it "gps fails and passes the response" do
            params, response = execute_dummy_expect_gps_fail(request_type)
            response.status.should == :failed
            response.success?.should be_false
            response.errors.should == ["Error Response: 500"]
          end
          it "returns an error if a required property is not present" do
            params = get_dummy_request_params(request_type)
            params.dottable!
            missing_param = params.first[0]
            params[missing_param] = nil
            response = execute_expect_success(request_type, params, false)
            response.status.should == :failed
            response.errors.count.should == 1
            response.errors[0].should == "The property '#{missing_param}' is not defined for Gps::Request::#{request_type.to_s.camelize}Request."
          end
        end
      end
    end
  end
end
