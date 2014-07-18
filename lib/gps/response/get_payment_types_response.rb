class Gps::Response::GetPaymentTypesResponse < Gps::Response::Base
  attr_accessor :payment_types

  def generate_response(typhoeus_response)
    response = super
    self.payment_types = response.payment_types
    response
  end
end