require 'sinatra/base'
require 'sequent'
require_relative 'invoices/commands'
require_relative 'invoices/event_handlers'
require_relative 'invoices/command_handlers'

class InvoicingApp < Sinatra::Base

  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  enable :sessions

  set :sequent_config_dir, root
  register Sequent::Web::Sinatra::App

  TENANT_ID = "sequent_company"

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

end

