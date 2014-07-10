class Gps::Request::AuthorizeRequest < Gps::Request::Base
  def type
    Gps::Request::Types::AUTHORIZE
  end

  def params_list
    super
  end

  def url
    "#{@host}/#{@url_params[:country_code]}/payments/"
  end

  def http_method
    :post
  end
end