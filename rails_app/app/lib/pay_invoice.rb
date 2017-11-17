class PayInvoice < TenantCommand
  include InvoiceCommand

  attrs pay_date: DateTime, tenant_id: String

  validates_presence_of :pay_date
end
