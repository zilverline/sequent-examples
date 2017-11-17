require_relative 'commands'
require_relative 'invoice'

class InvoiceCommandHandler < Sequent::Core::BaseCommandHandler
  def handles_message?(command)
    command.kind_of? InvoiceCommand
  end

  on CreateInvoiceCommand do |command|
    repository.add_aggregate Invoice.new(
                               command.aggregate_id,
                               command.organization_id,
                               command.amount,
                               command.recipient
                             )
  end

end
