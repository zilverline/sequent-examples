require_relative 'tenant_event'
require_relative 'recipient'

class InvoiceCreated < TenantEvent
  attrs amount: Integer, recipient: Recipient
end
