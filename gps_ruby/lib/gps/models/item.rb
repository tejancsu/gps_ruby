module Gps
  module Model
    class Item < Resource
      attribute :amount
      attribute :inventory_unit_id
      attribute :merchandising_product_id
      attribute :type
      attribute :voucher_group
      attribute :voucher_reference
    end
  end
end
