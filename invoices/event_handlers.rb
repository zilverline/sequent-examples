require_relative 'events'
require_relative 'records'

class InvoiceRecordEventHandler < Sequent::Core::BaseEventHandler

  on InvoiceCreatedEvent do |event|
    create_record(
      InvoiceRecord,
      aggregate_id: event.aggregate_id,
      sequence_number: event.sequence_number,
      organization_id: event.organization_id,
      amount: event.amount,
      recipient: event.recipient
    )
  end

  on InvoicePaidEvent do |event|
    update_record(InvoiceRecord, event) do |invoice_record|
      invoice_record.paid_at = event.paid_at
    end
  end

end

class InvoiceDashboardEventHandler < Sequent::Core::BaseEventHandler

  on InvoiceCreatedEvent do |event|
    totals = get_record(InvoiceTotalsRecord, {organization_id: event.organization_id})
    if totals.present?
      update_record(InvoiceTotalsRecord, event) do |record|
        record.total_amount += event.amount
        record.total_invoice_count += 1
      end
    else
      create_record(
        InvoiceTotalsRecord,
        aggregate_id: event.aggregate_id,
        sequence_number: event.sequence_number,
        organization_id: event.organization_id,
        total_amount: event.amount,
        total_invoice_count: 1
      )
    end

  end
end
