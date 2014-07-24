module Gps
  module Model
    class CreateBillingRecordRequest < Resource
      attribute :stubbed_response
      attribute :id
      attribute :type
      attribute :variant
      attribute :billing_address
      attribute :payment_data
      attribute :purchaser
    end
  end
end
