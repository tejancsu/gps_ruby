module Gps
  module Model
    class BillingRecord < Resource
      attribute :billing_address
      attribute :id
      attribute :payment_data
      attribute :purchaser
      attribute :type
      attribute :variant
    end
  end
end
