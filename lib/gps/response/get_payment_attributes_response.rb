class Gps::Response::GetPaymentAttributesResponse < Gps::Response::Base
  attr_accessor :payment_attributes

  def generate_response(typhoeus_response)
    response = super
    self.payment_attributes = response.payment_attributes
    response
  end
end
