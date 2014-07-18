class Gps::Request::CreateBillingRecordRequest < Gps::Request::Base

    property :billing_address, :required => true do
      property :postal_code, :required => false
      property :country_iso_code, :required => false
      property :state, :required => true
      property :district, :required => false
      property :city, :required => true
      property :address_line1, :required => true
      property :address_line2, :required => false
      property :name, :required => true
    end

    property :payment_data, :required => true do
      property :holder_name, :required => true
      property :number, :require => true
      property :cvv, :required => true
      property :expiry_month, :required => true
      property :expiry_year, :required => true
    end

    property :purchaser, :required => true do
      property :id, :required => true
      property :name, :require => false
      property :email, :required => false
    end

    property :id, :required => true
    property :type, :required => true
    property :variant, :required => true

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