require 'spec_helper'

describe Gps::Request::CreateBillingRecordRequest do
  def sample_billing_address
    Gps::Model::BillingAddress.new.tap do |billing_address|
      billing_address.postal_code      = '12345'
      billing_address.country_iso_code = 'DE'
      billing_address.state            = 'State'
      billing_address.district         = 'District'
      billing_address.city             = 'Town'
      billing_address.address_line1    = 'Street 12'
      billing_address.address_line2    = 'last House in the street'
      billing_address.name             = 'Mr & Ms Muster'
    end
  end

  def sample_payment_data
    Gps::Model::PaymentData.new.tap do |payment_data|
      payment_data.holder_name    = 'Max Muster'
      payment_data.number         = '4242424242424242'
      payment_data.cvv            = '1234'
      payment_data.expiry_month   = '12'
      payment_data.expiry_year    = '2017'
    end
  end

  def sample_purchaser
    Gps::Model::Purchaser.new.tap do |purchaser|
      purchaser.name           =' Marianne Muster'
      purchaser.email          = 'marianne.muster@example.com'
      purchaser.locale         = 'de_DE'
      purchaser.id             = UUIDTools::UUID.random_create
    end
  end

  let(:billing_record_request) do
    Gps::Model::CreateBillingRecordRequest.new.tap do |create_br|
      create_br.billing_address = sample_billing_address
      create_br.payment_data = sample_payment_data
      create_br.purchaser = sample_purchaser
      create_br.id = UUIDTools::UUID.random_create
      create_br.type = 'creditcard'
      create_br.variant = 'visa'
    end
  end

  let(:host) { mock('host') }

  it "creates request object successfully" do
    expect{ Gps::Request::CreateBillingRecordRequest.new(host, billing_record_request) }.to_not raise_error
  end

  context "when keys which are not defined properties exist in the request params" do
    it "creates request object successfully" do
      br_request_hash = billing_record_request.to_hash
      br_request_hash["bleh"] = "pgriffin"
      expect{ Gps::Request::CreateBillingRecordRequest.new(host, br_request_hash) }.to_not raise_error
    end
  end

  context "when a property is missing" do

    context "when variant is not present" do
      it "raises error as expected" do
        billing_record_request.variant = nil
        expect{ Gps::Request::CreateBillingRecordRequest.new(host, billing_record_request) }.to raise_error(Gps::Request::ParamsErrorException, "The property 'variant' is not defined for Gps::Request::CreateBillingRecordRequest.")
      end
    end

    context "when purchaser id is not present" do
      it "raises error as expected" do
        billing_record_request.purchaser.id = nil
        expect{ Gps::Request::CreateBillingRecordRequest.new(host, billing_record_request) }.to raise_error(Gps::Request::ParamsErrorException, "The property 'purchaser:id' is not defined for Gps::Request::CreateBillingRecordRequest.")
      end
    end
  end
end