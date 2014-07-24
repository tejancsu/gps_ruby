module Gps
  module Model
    class PaymentRequest < Resource
      attribute :stubbed_response
      attribute :country_code
      attribute :payment_details
      attribute :settlement_details
    end
  end
end
