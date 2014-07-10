class Gps::StubbedBillingRecord < Gps::BillingRecord

  def initialize
    initialize_stubbed_billing_record
  end

  private

  def initialize_stubbed_billing_record
    @id = UUIDTools::UUID.timestamp_create.to_s
    @consumer_id = UUIDTools::UUID.timestamp_create.to_s
    @created_at = Time.now
    @updated_at = Time.now
    @is_disabled = false
    @billing_id = "12345"
    @number = "****-1111"
    @first_name = "Test"
    @last_name = "Name"
    @full_name = "Test Name"
    @card_type = "visa"
    @billing_type = "creditcard"
    @month = 12
    @year = 2015
    @address1 = "3101, Park Blvd."
    @city = "Palo Alto"
    @state = "CA"
    @country_and_state = "US[California]"
    @zip = "94306"
    @country = "US"
    @gateway = 'Adyen'
    @active = true
    @consumer_id = "a025838c-7a26-11e2-8271-002590980712"
    @tokenized_pan = "4111111111111111"
  end
end