require "bundler"
Bundler.setup

require 'sinatra/base'
require 'sequent/sequent'
require_relative 'domain/invoice_commands'

class InvoicingApp < Sinatra::Base

  enable :sessions

  get '/' do
    @command = CreateInvoiceCommand.new(
      aggregate_id: new_uuid
    )
    erb :index
  end


  helpers Sequent::Web::Sinatra::FormHelpers
  helpers Sequent::Core::Helpers::UuidHelper
end
