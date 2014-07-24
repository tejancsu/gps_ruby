require 'json'

class Gps::Response::Base
  attr_accessor :status, :response, :errors

  def initialize(status, typhoeus_response)
    @status = status
    if status == :failed
      @response = typhoeus_response
      @errors = [typhoeus_response]
    else
      @response = generate_response(typhoeus_response)
    end
  end

  # Implemented by child classes
   def generate_response(typhoeus_response)
    (::JSON.parse typhoeus_response).dottable!
   end

  def success?
    @status == :succeeded
  end
end