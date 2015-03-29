require_relative '../invoices/records'
require_relative '../invoices/event_handlers'
require_relative '../invoices/command_handlers'
require 'sequent'

Sequent::Core::CommandService.configure do |command_service_config|
  # The event store
  command_service_config.event_store = Sequent::Core::EventStore.configure do |config|
    config.record_class = EventRecord
    config.event_handlers = [InvoiceRecordEventHandler, InvoiceDashboardEventHandler].map(&:new)
  end

  # The command handler classes.
  command_service_config.command_handler_classes = [InvoiceCommandHandler]

  # How to handle transactions
  command_service_config.transaction_provider = Sequent::Core::Transactions::ActiveRecordTransactionProvider.new

  # Optional filters, can be used to do for instance security checks.
  # command_service_config.filters = []
end
