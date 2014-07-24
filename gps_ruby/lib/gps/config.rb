# Behaves like AppConfig.gps
class Gps::Config

  DEFAULT_CONNECT_TIMEOUT = 2000
  DEFAULT_READ_TIMEOUT    = 5000

  attr_accessor :host, :attributes

  def initialize
    @host       = 'http://127.0.0.1:8080'
    @attributes = {
        'authorize'              => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'capture'                => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'refund'                 => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'cancel'                 => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'complete_auth'          => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'show_payment'           => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'get_billing_records'    => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'create_billing_record'  => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'get_payment_types'      => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT},
        'get_payment_attributes' => {'connect_timeout' => DEFAULT_CONNECT_TIMEOUT, 'read_timeout' => DEFAULT_READ_TIMEOUT}
    }
  end

  def [](key)
    @attributes[key]
  end
end
