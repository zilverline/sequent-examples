require_relative 'commands'
require_relative 'invoice'

class InvoiceCommandHandler < Sequent::Core::BaseCommandHandler
  def handles_message?(command)
    command.is_a? InvoiceCommand
  end

  on CreateInvoice do |command|

    repository.add_aggregate Invoice.new(
      command.aggregate_id,
      command.tenant_id,
      command.amount,
      command.recipient
    )
  end

end
