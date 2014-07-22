require 'spec_helper'

describe Gps::Request::CreateBillingRecordRequest do
  def sample_billing_address
    {
      :postal_code      => '12345',
      :country_iso_code => 'DE',
      :state            => 'State',
      :district         => 'District',
      :city             => 'Town',
      :address_line1    => 'Street 12',
      :address_line2    => 'last House in the street',
      :name             => 'Mr & Ms Muster'
    }
  end

  def sample_payment_data
    {
      :holder_name  => 'Max Muster',
      :number       => '4242424242424242',
      :cvv          => '1234',
      :expiry_month => '12',
      :expiry_year  => '2017'
    }
  end

  def sample_purchaser
    {
      :name   => ' Marianne Muster',
      :email  => 'marianne.muster@example.com',
      :locale => 'de_DE',
      :id     => UUIDTools::UUID.random_create
    }
  end

  let(:billing_record_request) do
    {
      :billing_address => sample_billing_address,
      :payment_data => sample_payment_data,
      :purchaser => sample_purchaser,
      :id => UUIDTools::UUID.random_create,
      :type => 'creditcard',
      :variant => 'visa'
    }
  end

  let(:host) { mock('host') }

  it "creates request object successfully" do
    expect{ Gps::Request::CreateBillingRecordRequest.new(host, billing_record_request) }.to_not raise_error
  end

  context "when keys which are not defined properties exist in the request params" do
    it "creates request object successfully" do
      br_request_hash = billing_record_request
      br_request_hash["bleh"] = "pgriffin"
      expect{ Gps::Request::CreateBillingRecordRequest.new(host, br_request_hash) }.to_not raise_error
    end
  end

  context "when a property is missing" do

    context "when variant is not present" do
      it "raises error as expected" do
        billing_record_request[:variant] = nil
        expect{ Gps::Request::CreateBillingRecordRequest.new(host, billing_record_request) }.to raise_error(Gps::Request::ParamsErrorException, "The property 'variant' is not defined for Gps::Request::CreateBillingRecordRequest.")
      end
    end

    context "when purchaser id is not present" do
      it "raises error as expected" do
        billing_record_request[:purchaser][:id] = nil
        expect{ Gps::Request::CreateBillingRecordRequest.new(host, billing_record_request) }.to raise_error(Gps::Request::ParamsErrorException, "The property 'purchaser:id' is not defined for Gps::Request::CreateBillingRecordRequest.")
      end
    end
  end
end