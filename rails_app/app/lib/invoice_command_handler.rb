require 'sequent'

class InvoiceCommandHandler < Sequent::Core::BaseCommandHandler
  on CreateInvoice do |command|

    repository.add_aggregate Invoice.new(
      command.aggregate_id,
      command.tenant_id,
      command.amount,
      command.recipient
    )
  end
end
