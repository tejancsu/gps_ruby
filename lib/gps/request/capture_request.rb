class Gps::Request::CaptureRequest < Gps::Request::Base

  property :country_code
  property :payment_id
  
  property :capture_details do
    property :id

    property :amount do
      property :value
      property :currency_code
    end
  end

  def type
    Gps::Request::Types::CAPTURE
  end

  def url
    "#{@host}/#{@params.country_code}/payments/#{@params.payment_id}/capture"
  end

  def http_method
    :put
  end
end