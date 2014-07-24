class Gps::Request::GetPaymentAttributesRequest < Gps::Request::Base
  property :country_code
  property :payment_type

  def type
    Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
  end

  def url
    "#{@host}/#{@params.country_code}/payment_types/#{@params.payment_type}/payment_attributes"
  end

  def http_method
    :get
  end
end