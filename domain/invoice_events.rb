require_relative 'value_objects'

class InvoiceCreatedEvent < Sequent::Core::CreateEvent
  attrs amount: Integer, recipient: String
end

class InvoicePaidEvent < Sequent::Core::Event
  attrs paid_at: Date
end
