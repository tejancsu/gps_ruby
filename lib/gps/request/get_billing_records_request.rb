class Gps::Request::GetBillingRecordsRequest < Gps::Request::Base
  def type
    Gps::Request::Types::GET_BILLING_RECORDS
  end

  def params_list
    super.merge(
      {
        :consumer_id => { :required => true },
        :billing_record_ids => { :required => true },
        :active_only => { :required => true }
      }
    )
  end

  def url
    "#{@host}/temporary_get_billing_records"
  end

  def http_method
    :get
  end
end