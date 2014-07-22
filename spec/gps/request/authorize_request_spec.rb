require 'spec_helper'

describe Gps::Request::AuthorizeRequest do
  let(:authorize_request) do
    {
      :payment_details => payment_details,
      :settlement_details => settlement_details
    }
  end

  let(:payment_details) do
    {
      :id => UUIDTools::UUID.random_create,
      :database_id => 12345,
      :payment_support_reference => "aoeuaoeu1",
      :billing_record => billing_record,
      :amount => amount,
      :application_base_url => "aoeuaoeu.com",
      :context => context
    }
  end

  let(:settlement_details) do
    {
      :version => "1.0",
      :items => {}
    }
  end

  let(:billing_record) do
    {
      :id => UUIDTools::UUID.random_create
    }
  end

  let(:amount) do
    {
      :value         => 1234,
      :currency_code => 'USD'
    }
  end

  let(:context) do
    {
      :client_ip        => '127.0.0.0.1',
      :origin_client_id => 'iOS-id',
      :client_id        => 'aoeuaoeu',
      :accept_header    => 'headers!',
      :user_agent       => 'hello me'
    }
  end

  let(:host) { mock('host') }

  it "creates request object successfully" do
    expect{ Gps::Request::AuthorizeRequest.new(host, authorize_request) }.to_not raise_error
  end

  context "when keys which are not defined properties exist in the request params" do
    it "creates request object successfully" do
      authorize_request_hash = authorize_request
      authorize_request_hash["bleh"] = "pgriffin"
      expect{ Gps::Request::AuthorizeRequest.new(host, authorize_request_hash) }.to_not raise_error
    end
    it "is accessible in the request body" do
      authorize_request_hash = authorize_request
      authorize_request_hash["bleh"] = "pgriffin"
      request = Gps::Request::AuthorizeRequest.new(host, authorize_request_hash)
      request.body.should match("bleh")
      request.body.should match("pgriffin")
    end
  end

  context "when a property is missing" do

    context "when amount.currency_code is not present" do
      it "raises error as expected" do
        authorize_request[:payment_details][:amount][:currency_code] = nil
        expect{ Gps::Request::AuthorizeRequest.new(host, authorize_request) }.to raise_error(Gps::Request::ParamsErrorException, "The property 'payment_details:amount:currency_code' is not defined for Gps::Request::AuthorizeRequest.")
      end
    end
  end
end