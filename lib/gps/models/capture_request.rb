module Gps
  module Model
    class CaptureRequest < Resource
      attribute :stubbed_response
      attribute :country_code
      attribute :payment_id
      attribute :capture_details
      attribute :settlement_details
    end
  end
end
