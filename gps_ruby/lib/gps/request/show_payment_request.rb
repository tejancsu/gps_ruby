class Gps::Request::ShowPaymentRequest < Gps::Request::Base
  property :country_code
  property :payment_id

  def type
    Gps::Request::Types::SHOW_PAYMENT
  end

  def url
    "#{@host}/#{@params.country_code}/payments/#{@params.payment_id}"
  end

  def http_method
    :get
  end
end