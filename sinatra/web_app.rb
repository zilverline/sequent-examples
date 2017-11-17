require 'sinatra/base'
require 'sequent'
require_relative 'invoices/commands'
require_relative 'invoices/event_handlers'
require_relative 'invoices/command_handlers'

class WebApp < Sinatra::Base

  after do
    ActiveRecord::Base.clear_active_connections!
  end

  enable :sessions

  set :sequent_config_dir, root

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    also_reload File.expand_path("**/*.rb", __FILE__)
    dont_reload File.expand_path("db/**/*.rb", __FILE__)
  end

  TENANT_ID = 'example_tenant'

  get '/' do
    @command = CreateInvoice.new(
      aggregate_id: Sequent.new_uuid,
      tenant_id: TENANT_ID
    )
    erb :index
  end

  post '/' do
    @command = CreateInvoice.from_params(params[:create_invoice])
    p command: @command

    begin
      Sequent.command_service.execute_commands(@command)
      redirect back
    rescue Sequent::Core::CommandNotValid
      erb :index # render same page and display error
    end
  end

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end
end

