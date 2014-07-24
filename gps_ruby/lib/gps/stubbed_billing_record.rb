class Gps::StubbedBillingRecord
 def billing_record
    {
     "id" => UUIDTools::UUID.timestamp_create.to_s,
     "type" => 'creditcard',
     "variant" => 'visa',
     "billing_address" => {
                          "postal_code"      => '12345',
                          "country_iso_code" => 'DE',
                          "state"            => 'State',
                          "district"         => 'District',
                          "city"             => 'Town',
                          "address_line1"    => 'Street 12',
                          "address_line2"    => 'last House in the street',
                          "name"             => 'Mr & Ms Muster'
                          },
     "payment_data" =>  {
                        "holder_name"    => 'Max Muster',
                        "number"         => '4242424242424242',
                        "cvv"            => '1234',
                        "expiry_month"   => '12',
                        "expiry_year"    => '2017'
                        },
     "purchaser" => {
                      "name"           => 'Marianne Muster',
                      "email"          => 'marianne.muster@example.com',
                      "locale"         => 'de_DE',
                      "id"             => UUIDTools::UUID.random_create
                    },
     "created_at" => Time.now,
     "updated_at" => Time.now,
     "active" => true
    }
  end
end