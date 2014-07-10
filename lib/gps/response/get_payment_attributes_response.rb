class Gps::Response::GetPaymentAttributesResponse < Gps::Response::Base
  attr_accessor :payment_attributes

  def generate_response(typhoeus_response)
    self.payment_attributes = typhoeus_response.payment_attributes
  end
end
