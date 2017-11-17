require_relative 'events'
require_relative 'records'

class InvoiceRecordEventHandler < Sequent::Core::BaseEventHandler

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

class InvoiceDashboardEventHandler < Sequent::Core::BaseEventHandler

  on InvoiceCreated do |event|
    totals = get_record(InvoiceTotalsRecord, tenant_id: event.tenant_id)
    if totals.present?
      update_record(InvoiceTotalsRecord, event, tenant_id: event.tenant_id) do |record|
        record.total_amount += event.amount
        record.total_invoice_count += 1
      end
    else
      create_record(
        InvoiceTotalsRecord,
        tenant_id: event.tenant_id,
        total_amount: event.amount,
        total_invoice_count: 1
      )
    end

  end
end
