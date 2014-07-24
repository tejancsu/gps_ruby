class Gps::Request::GetPaymentTypesRequest < Gps::Request::Base
  property :country_code

  def type
    Gps::Request::Types::GET_PAYMENT_TYPES
  end

  def url
    "#{@host}/#{@params.country_code}/payment_types"
  end

  def http_method
    :get
  end
end