class Gps::Request::CreateBillingRecordRequest < Gps::Request::Base

  property :billing_address do
    property :postal_code, :required => false
    property :country_iso_code, :required => false
    property :state
    property :district, :required => false
    property :city
    property :address_line1
    property :address_line2, :required => false
    property :name
  end

  property :payment_data do
    property :holder_name
    property :number
    property :cvv
    property :expiry_month
    property :expiry_year
  end

  property :purchaser do
    property :id
    property :name, :required => false
    property :email, :required => false
  end

  property :id
  property :type
  property :variant

  def type
    Gps::Request::Types::CREATE_BILLING_RECORD
  end

  def url
    "#{@host}/temporary_create_billing_record_request"
  end

  def http_method
    :post
  end

end