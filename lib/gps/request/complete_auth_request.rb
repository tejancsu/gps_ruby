class Gps::Request::CompleteAuthRequest < Gps::Request::Base
  property :country_code
  property :payment_id

  def type
    Gps::Request::Types::COMPLETE_AUTH
  end

  def url
    "#{@host}/#{@params.country_code}/#{@params.payment_id}/complete-auth"
  end

  def http_method
    :put
  end
end
