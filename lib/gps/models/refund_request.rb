module Gps
  module Model
    class RefundRequest < Resource
      attribute :stubbed_response
      attribute :country_code
      attribute :payment_id
      attribute :refund_details
      attribute :settlement_details
    end
  end
end
