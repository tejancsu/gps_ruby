class Gps::Request::AuthorizeRequest < Gps::Request::Base

  property :country_code

  property :payment_details do
    property :id
    property :database_id
    property :payment_support_reference

    property :billing_record

    property :amount do
      property :value
      property :currency_code
    end

    property :application_base_url

    property :context do
      property :client_ip
      property :origin_client_id
      property :client_id
      property :accept_header
      property :user_agent
    end
  end

  property :settlement_details do
    property :version
    property :items
  end

  def type
    Gps::Request::Types::AUTHORIZE
  end

  def url
    "#{@host}/#{@params.country_code}/payments/"
  end

  def http_method
    :post
  end
end