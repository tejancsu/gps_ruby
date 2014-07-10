class Gps::Response::CreateBillingRecordResponse < Gps::Response::Base
  attr_accessor :billing_record

  def generate_response(typhoeus_response)
    self.billing_record = typhoeus_response.billing_record
  end
end