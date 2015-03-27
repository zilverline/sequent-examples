require_relative 'value_objects'

class InvoiceCreatedEvent < Sequent::Core::CreateEvent
  attrs amount: Integer, recipient: Recipient
end

class InvoicePaidEvent < Sequent::Core::TenantEvent
  attrs paid_at: Date
end
