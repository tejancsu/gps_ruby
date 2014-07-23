module Gps
  module Model
    class UpdateRequest < Resource
      attribute :stubbed_response
      attribute :country_code
      attribute :payment_id
      attribute :update_details
    end
  end
end
