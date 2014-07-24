class Gps::Request::Base

  include ::Gps::RequestValidator

  attr_accessor :stubbed_response, :params
  # params can be a hash or a Gps::Model instance
  def initialize(host, params)
    @host = host
    @params = params
    self.validate_request(@params)
    @stubbed_response = params.stubbed_response if params.respond_to?(:stubbed_response)
  end

  # The child classes will add the parameters relevant
  def body
    @params.to_json
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

  # Implemented in child class
  def type
    raise Gps::Request::TypeMissingException.new("The Gps Request does not have the type implemented.  #{@params.inspect}")
  end

  def raise_no_property_error!(property_name)
    raise Gps::Request::ParamsErrorException, "The property '#{property_name}' is not defined for #{self.class.name}."
  end
end
