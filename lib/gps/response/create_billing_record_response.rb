class Gps::Response::CreateBillingRecordResponse < Gps::Response::Base
  attr_accessor :billing_record

  def initialize(status, typhoeus_response)
    super(status, typhoeus_response)
    if success?
      @billing_record = @response.dottable!
    end
  end
end