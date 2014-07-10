class Gps::Request::RefundRequest < Gps::Request::Base
  def type
    Gps::Request::Types::REFUND
  end

  def params_list
    super.merge({ :payment_id => { :required => true } })
  end

  def url
    "#{@host}/#{@url_params[:country_code]}/payments/#{@url_params[:payment_id]}/refund"
  end

  def http_method
    :put
  end
end