class Gps::Request::GetBillingRecordsRequest < Gps::Request::Base
  property :country_code
  property :consumer_id
  
  def type
    Gps::Request::Types::GET_BILLING_RECORDS
  end

  def url
    "#{@host}/temporary_get_billing_records"
  end

  def http_method
    :get
  end
end