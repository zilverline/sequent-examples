require 'sequent'
require_relative 'invoice_created'
require_relative 'invoice_paid'

class InvoiceProjector < Sequent::Core::Projector
  on InvoiceCreated do |event|
    create_record(
      InvoiceRecord,
      aggregate_id: event.aggregate_id,
      tenant_id: event.tenant_id,
      amount: event.amount,
      recipient_name: event.recipient.name
    )
  end

  on InvoicePaid do |event|
    update_record(InvoiceRecord, event) do |invoice_record|
      invoice_record.paid_at = event.paid_at
    end
  end

end
