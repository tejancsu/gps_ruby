class Gps::Request::CreateBillingRecordRequest < Gps::Request::Base
  def type
    Gps::Request::Types::CREATE_BILLING_RECORD
  end

  def params_list
    super.merge(
      {
        :billing_record_request => { :required => true },
        :consumer_id => { :required => true }
      }
    )
  end

  def url
    "#{@host}/temporary_create_billing_record_requqest"
  end

  def http_method
    :post
  end
end