class Gps::PaymentType
  attr_accessor :billing_record_type, :cc_type

  def initialize(billing_record_type, cc_type=nil)
    @billing_record_type = billing_record_type
    @cc_type = cc_type
  end
end