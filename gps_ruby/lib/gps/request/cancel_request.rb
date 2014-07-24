class Gps::Request::CancelRequest < Gps::Request::Base
  property :country_code
  property :payment_id

  def type
    Gps::Request::Types::CANCEL
  end

  def url
    "#{@host}/#{@params.country_code}/payments/#{@params.payment_id}"
  end

  def http_method
    :delete
  end
end