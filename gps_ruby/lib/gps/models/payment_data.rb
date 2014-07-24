module Gps
  module Model
    class PaymentData < Resource
      attribute :cvv
      attribute :expiry_month
      attribute :expiry_year
      attribute :holder_name
      attribute :number
    end
  end
end
