class Gps::Request::CancelRequest < Gps::Request::Base
  def type
    Gps::Request::Types::CANCEL
  end

  def params_list
    super.merge({ :payment_id => { :required => true } })
  end

  def url
    "#{@host}/#{@url_params[:country_code]}/payments/#{@url_params[:payment_id]}"
  end

  def http_method
    :delete
  end
end