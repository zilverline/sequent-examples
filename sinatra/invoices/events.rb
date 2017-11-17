require_relative 'value_objects'
require_relative 'multitenancy'

class InvoiceCreated < TenantEvent
  attrs amount: Integer, recipient: Recipient
end

class InvoicePaid < TenantEvent
  attrs paid_at: Date
end
