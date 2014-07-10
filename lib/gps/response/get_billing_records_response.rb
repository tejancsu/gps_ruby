class Gps::Response::GetBillingRecordsResponse < Gps::Response::Base
  attr_accessor :billing_records

  def generate_response(typhoeus_response)
    self.billing_records = typhoeus_response.billing_records
  end
end