require 'spec_helper'

describe Gps::Request::CaptureRequest do
  let(:capture_request) do
    {
      :country_code => 'US',
      :payment_id => UUIDTools::UUID.random_create,
      :capture_details => capture_details
    }
  end

  let(:capture_details) do
    {
      :id => UUIDTools::UUID.random_create,
      :amount => amount
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
    expect{ Gps::Request::CaptureRequest.new(host, capture_request) }.to_not raise_error
  end

  context "when keys which are not defined properties exist in the request params" do
    it "creates request object successfully" do
      capture_request_hash = capture_request
      capture_request_hash["bleh"] = "pgriffin"
      expect{ Gps::Request::CaptureRequest.new(host, capture_request_hash) }.to_not raise_error
    end
    it "is accessible in the request body" do
      capture_request_hash = capture_request
      capture_request_hash["bleh"] = "pgriffin"
      request = Gps::Request::CaptureRequest.new(host, capture_request_hash)
      request.body.should match("bleh")
      request.body.should match("pgriffin")
    end
  end

  context "when a property is missing" do

    context "when amount.currency_code is not present" do
      it "raises error as expected" do
        capture_request[:capture_details][:amount][:currency_code] = nil
        expect{ Gps::Request::CaptureRequest.new(host, capture_request) }.to raise_error(Gps::Request::ParamsErrorException, "The property 'capture_details:amount:currency_code' is not defined for Gps::Request::CaptureRequest.")
      end
    end
  end
end