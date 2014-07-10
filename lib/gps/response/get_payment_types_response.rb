class Gps::Response::GetPaymentTypesResponse < Gps::Response::Base
  attr_accessor :payment_types

  def generate_response(typhoeus_response)
    self.payment_types = typhoeus_response.payment_types
  end
end