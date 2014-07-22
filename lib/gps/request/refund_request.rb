class Gps::Request::RefundRequest < Gps::Request::Base
  property :country_code
  property :payment_id

  property :refund_details do
    property :id

    property :amount do
      property :value
      property :currency_code
    end
  end

  property :settlement_details do
    property :version
    property :items
  end

  def type
    Gps::Request::Types::REFUND
  end

  def url
    "#{@host}/#{@params.country_code}/payments/#{@params.payment_id}/refund"
  end

  def http_method
    :put
  end
end