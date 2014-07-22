require 'spec_helper'

describe Gps::Client do

  it 'should be able to auth, full capture and full refund', :integration => true do
    gps_client = Gps::Client.new(Gps::Config.new, Gps::Logger.new)

    # Auth
    payment_id = auth(gps_client)

    # Capture the full amount
    capture(gps_client, payment_id)

    # Refund the full amount
    refund(gps_client, payment_id)
  end

  private

  def auth(gps_client)
    payment_id = UUIDTools::UUID.timestamp_create.to_s

    details    = Gps::Model::PaymentDetails.new
    details.id = payment_id
    details.database_id = 1234
    details.payment_support_reference = 'aoeuaoeu'

    billing_record         = Gps::Model::BillingRecord.new
    billing_record.id      = UUIDTools::UUID.timestamp_create.to_s
    billing_record.type    = 'creditcard'
    billing_record.variant = 'visa'

    billing_address                  = Gps::Model::BillingAddress.new
    billing_address.postal_code      = '12345'
    billing_address.country_iso_code = 'DE'
    billing_address.state            = 'State'
    billing_address.district         = 'District'
    billing_address.city             = 'Town'
    billing_address.address_line1    = 'Street 12'
    billing_address.address_line2    = 'last House in the street'
    billing_address.name             = 'Mr & Ms Muster'
    billing_record.billing_address   = billing_address

    payment_data                = Gps::Model::PaymentData.new
    payment_data.holder_name    = 'Max Muster'
    payment_data.number         = '4242424242424242'
    payment_data.cvv            = '1234'
    payment_data.expiry_month   = '12'
    payment_data.expiry_year    = '2017'
    billing_record.payment_data = payment_data

    purchaser                = Gps::Model::Purchaser.new
    purchaser.id             = UUIDTools::UUID.timestamp_create.to_s
    purchaser.name           ='Marianne Muster'
    purchaser.email          ='marianne.muster@example.com'
    purchaser.locale         ='de_DE'
    billing_record.purchaser = purchaser

    details.billing_record = billing_record

    amount               = Gps::Model::Amount.new
    amount.value         = 617
    amount.currency_code = 'USD'
    details.amount       = amount

    details.application_base_url = 'www.groupon.de/checkout'

    context                  = Gps::Model::Context.new
    context.accept_header    = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
    context.client_ip        = '127.0.0.1'
    context.client_id        = 'orders-client-id'
    context.origin_client_id = 'iOS-client-id'
    context.user_agent       = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36'
    details.context          = context

    settlement_details         = Gps::Model::SettlementDetails.new
    settlement_details.version = '1.0'
    settlement_details.items   = []

    amount1               = Gps::Model::Amount.new
    amount1.value         = 617
    amount1.currency_code = 'USD'
    item1                 = Gps::Model::Item.new
    item1.amount          = amount1
    item1.type            = 'GLOBAL_TRAVEL'
    settlement_details.items << item1

    amount2               = Gps::Model::Amount.new
    amount2.value         = 617
    amount2.currency_code = 'USD'
    item2                 = Gps::Model::Item.new
    item2.amount          = amount2
    item2.type            = 'LOCAL'
    settlement_details.items << item2

    request                    = Gps::Model::PaymentRequest.new
    request.payment_details    = details
    request.settlement_details = settlement_details

    response = gps_client.execute(Gps::Request::Types::AUTHORIZE, request, {:country_code => 'US', :payment_id => payment_id})
    response.status.should == :succeeded
    response.success?.should be_true
    response.errors.should be_nil

    payment_id
  end

  def capture(gps_client, payment_id)
    request = Gps::Model::CaptureRequest.new

    amount               = Gps::Model::Amount.new
    amount.value         = 617
    amount.currency_code = 'USD'

    details        = Gps::Model::CaptureDetails.new
    details.id     = UUIDTools::UUID.timestamp_create.to_s
    details.amount = amount

    request.capture_details = details

    response = gps_client.execute(Gps::Request::Types::CAPTURE, request, {:country_code => 'US', :payment_id => payment_id})
    response.status.should == :succeeded
    response.success?.should be_true
    response.errors.should be_nil
  end

  def refund(gps_client, payment_id)
    request = Gps::Model::RefundRequest.new

    amount               = Gps::Model::Amount.new
    amount.value         = 617
    amount.currency_code = 'USD'

    details        = Gps::Model::RefundDetails.new
    details.id     = UUIDTools::UUID.timestamp_create.to_s
    details.amount = amount

    request.refund_details = details

    response = gps_client.execute(Gps::Request::Types::REFUND, request, {:country_code => 'US', :payment_id => payment_id})
    response.status.should == :succeeded
    response.success?.should be_true
    response.errors.should be_nil
  end
end
