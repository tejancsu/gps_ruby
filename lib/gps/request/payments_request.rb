class Gps::Request::PaymentsRequest < Gps::Request::Base

  def params_list
    super.merge({ :payment_id => { :required => true } })
  end

  def type
    Gps::Request::Types::PAYMENTS
  end

  def url
    "#{@host}/#{@url_params[:country_code]}/#{@url_params[:payment_id]}/complete"
  end

  def http_method
    :put
  end
end
