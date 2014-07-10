class Gps::Request::Base

  # raw_params can be a hash or a Gps::Model instance
  def initialize(host, raw_params, url_params = {})
    @host = host
    @raw_params = raw_params
    @url_params = url_params
    @params = params
  end

  # The child classes will add the parameters relevant
  def body
    @raw_params.to_json
  end

  #Implement in child class
  def url
    raise "Implement in child class"
  end

  # Implement in child class
  def http_method
    raise "Implement in child class"
  end

  # The child classes will add other relevant info, if any.
  def logger_info
    {
      :url => url,
      :body => body.inspect
    }
  end

  def params
    params = params_list
    params.each do |k, v|
      if @url_params[k].nil? && v[:required] == true
        raise Gps::Request::ParamsErrorException.new("Gps Request Param Error: request:#{self.type} is missing required parameter #{k}.")
      else
        params[k] = @url_params[k]
      end
    end

    params.merge(:stubbed_response => @url_params[:stubbed_response])
  end

  #Child should merge any other params thats required
  def params_list
    { :country_code => { :required => true } }
  end

  # Implemented in child class
  def type
    raise Gps::Request::TypeMissingException.new("The Gps Request does not have the type implemented.  #{@params.inspect}")
  end
end
