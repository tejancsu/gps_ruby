class Gps::Response::GetBillingRecordsResponse < Gps::Response::Base
  attr_accessor :billing_records

  def generate_response(typhoeus_response)
    response = super
    self.billing_records = response.billing_records
    response
  end
end