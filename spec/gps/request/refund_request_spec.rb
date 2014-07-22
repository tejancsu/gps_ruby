require 'spec_helper'

describe Gps::Request::RefundRequest do
  let(:refund_request) do
    {
      :country_code => 'US',
      :payment_id => UUIDTools::UUID.random_create.to_s,
      :refund_details => refund_details,
      :settlement_details => settlement_details
    }
  end

  let(:refund_details) do
    {
      :id => UUIDTools::UUID.random_create.to_s,
      :amount => amount
    }
  end

  let(:settlement_details) do
    {
      :version => "1.0",
      :items => {}
    }
  end

  let(:amount) do
    {
      :value         => 1234,
      :currency_code => 'USD'
    }
  end

  let(:host) { mock('host') }

  it "creates request object successfully" do
    expect{ Gps::Request::RefundRequest.new(host, refund_request) }.to_not raise_error
  end

  context "when keys which are not defined properties exist in the request params" do
    it "creates request object successfully" do
      refund_request_hash = refund_request
      refund_request_hash["bleh"] = "pgriffin"
      expect{ Gps::Request::RefundRequest.new(host, refund_request_hash) }.to_not raise_error
    end
    it "is accessible in the request body" do
      refund_request_hash = refund_request
      refund_request_hash["bleh"] = "pgriffin"
      request = Gps::Request::RefundRequest.new(host, refund_request_hash)
      request.body.should match("bleh")
      request.body.should match("pgriffin")
    end
  end

  context "when a property is missing" do

    context "when amount.currency_code is not present" do
      it "raises error as expected" do
        refund_request[:refund_details][:amount][:currency_code] = nil
        expect{ Gps::Request::RefundRequest.new(host, refund_request) }.to raise_error(Gps::Request::ParamsErrorException, "The property 'refund_details:amount:currency_code' is not defined for Gps::Request::RefundRequest.")
      end
    end
  end
end