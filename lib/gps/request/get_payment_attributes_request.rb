class Gps::Request::GetPaymentAttributesRequest < Gps::Request::Base
  def type
    Gps::Request::Types::GET_PAYMENT_ATTRIBUTES
  end

  def params_list
    super.merge({ :payment_type => { :required => true } })
  end

  def url
    "#{@host}/#{@url_params[:country_code]}/payment_types/#{@url_params[:payment_type]}/payment_attributes"
  end

  def http_method
    :get
  end
end