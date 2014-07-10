module Gps::Request::Types
  AUTHORIZE = :authorize
  CAPTURE = :capture
  CANCEL = :cancel
  REFUND = :refund
  PAYMENTS = :payments
  CREATE_BILLING_RECORD = :create_billing_record
  GET_BILLING_RECORDS = :get_billing_records
  GET_PAYMENT_ATTRIBUTES = :get_payment_attributes
  GET_PAYMENT_TYPES = :get_payment_types

  ALL = [
    AUTHORIZE,
    CAPTURE,
    CANCEL,
    REFUND,
    PAYMENTS,
    CREATE_BILLING_RECORD,
    GET_BILLING_RECORDS,
    GET_PAYMENT_ATTRIBUTES,
    GET_PAYMENT_TYPES
  ]
end
