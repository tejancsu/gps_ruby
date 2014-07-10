module Gps
  module Model
    class BillingAddress < Resource
      attribute :address_line1
      attribute :address_line2
      attribute :city
      attribute :country_iso_code
      attribute :district
      attribute :name
      attribute :postal_code
      attribute :state
    end
  end
end
