require_relative 'value_objects'

module InvoiceCommand

end

class CreateInvoiceCommand < Sequent::Core::TenantCommand
  include Sequent::Core::Helpers::StringSupport
  include InvoiceCommand

  attrs amount: Integer, recipient: Recipient

  validates_presence_of :amount
  validates_presence_of :recipient

end

class PayInvoiceCommand < Sequent::Core::TenantCommand
  include Sequent::Core::Helpers::StringSupport
  include InvoiceCommand
  attrs pay_date: DateTime

  validates_presence_of :pay_date
end
