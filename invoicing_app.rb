require 'sinatra/base'
require 'sequent/sequent'
require_relative 'invoices/commands'
require_relative 'invoices/event_handlers'
require_relative 'invoices/command_handlers'

class InvoicingApp < Sinatra::Base

  use ActiveRecord::ConnectionAdapters::ConnectionManagement

  enable :sessions

  TENANT_ID = "sequent_company"

  before do
    event_store = Sequent::Core::TenantEventStore.new(
      EventRecord,
      [InvoiceRecordEventHandler, InvoiceDashboardEventHandler].map(&:new)
    )
    @command_service = Sequent::Core::CommandService.new(
      event_store,
      [InvoiceCommandHandler],
      Sequent::Core::Transactions::ActiveRecordTransactionProvider.new
    )
  end

  get '/' do
    @command = CreateInvoiceCommand.new(
      aggregate_id: new_uuid,
      organization_id: TENANT_ID
    )
    erb :index
  end

  post '/' do
    @command = CreateInvoiceCommand
                 .from_params(params[:create_invoice_command])
                 .merge!(organization_id: TENANT_ID)
    execute_command @command, :index do
      # success
      redirect back
    end
  end


  helpers Sequent::Web::Sinatra::FormHelpers
  helpers Sequent::Web::Sinatra::SimpleCommandServiceHelpers
  helpers Sequent::Core::Helpers::UuidHelper
end
