class Gps::Request::GetPaymentTypesRequest < Gps::Request::Base
  def type
    Gps::Request::Types::GET_PAYMENT_TYPES
  end

  def params_list
    super
  end

  def url
    "#{@host}/#{@url_params[:country_code]}/payment_types"
  end

  def http_method
    :get
  end
end