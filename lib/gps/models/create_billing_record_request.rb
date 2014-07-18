module Gps
  module Model
    class CreateBillingRecordRequest < Resource
      attribute :id
      attribute :type
      attribute :variant
      attribute :billing_address
      attribute :payment_data
      attribute :purchaser
    end
  end
end
