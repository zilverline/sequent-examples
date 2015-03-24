require_relative 'commands'

class InvoiceCommandHandler < Sequent::Core::BaseCommandHandler
  def handles_message?(command)
    command.kind_of? InvoiceCommand
  end

  on CreateInvoiceCommand do |command|
    repository.add_aggregate Invoice.new(

                             )
  end

end
