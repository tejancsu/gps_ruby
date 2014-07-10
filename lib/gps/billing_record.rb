class Gps::BillingRecord
  attr_reader :id, :consumer_id, :number, :first_name, :last_name, :full_name, :billing_type, :card_type, :month, :year, :address1, :address2, :city, :state, :country_and_state, :zip, :country, :gateway, :active, :is_disabled, :tokenized_pan, :created_at, :billing_id, :gateway_token

  alias :token :billing_id

  def initialize(billing_record_params={})
    stubbed_br = Gps::StubbedBillingRecord.new
    @id = stubbed_br.id
    @consumer_id = stubbed_br.consumer_id
    @billing_type = stubbed_br.billing_type
  end

  def disabled?
    is_disabled
  end

  def currency_codes
    []
  end
end