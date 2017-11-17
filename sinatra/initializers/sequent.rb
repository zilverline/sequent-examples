require_relative '../invoices/records'
require_relative '../invoices/event_handlers'
require_relative '../invoices/command_handlers'
require 'sequent'

Sequent.configure do |config|
  ### App configurations

  # Command handler classes
  config.command_handlers = [InvoiceCommandHandler.new]

  # Optional filters, can be used to do for instance security checks.
  config.command_filters = []

  # Event handler classes
  config.event_handlers = [InvoiceRecordEventHandler.new, InvoiceDashboardEventHandler.new]


  #### Configured by default but can be overridden:

  # config.event_store
  # config.command_service
  # config.record_class

  # How to handle transactions
  config.transaction_provider = Sequent::Core::Transactions::ActiveRecordTransactionProvider.new
end
