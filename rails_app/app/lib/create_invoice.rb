require_relative 'tentant_command'
require_relative 'invoice_command'

class CreateInvoice < TenantCommand
  include InvoiceCommand

  attrs amount: Integer, recipient: Recipient

  validates_presence_of :amount
  validates_presence_of :recipient

end
