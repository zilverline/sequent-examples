require_relative 'value_objects'
require_relative 'multitenancy'

module InvoiceCommand

end

class CreateInvoice < TenantCommand
  include InvoiceCommand

  attrs amount: Integer, recipient: Recipient

  validates_presence_of :amount
  validates_presence_of :recipient

end

class PayInvoice < TenantCommand
  include InvoiceCommand

  attrs pay_date: DateTime, tenant_id: String

  validates_presence_of :pay_date
end
