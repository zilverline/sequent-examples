require 'sequent'
require 'sequent/support'
require 'erb'
require_relative 'invoices/event_handlers'

module InvoicingApp
  VERSION = 1

  VIEW_PROJECTION = Sequent::Support::ViewProjection.new(
    name: "view",
    version: VERSION,
    definition: "db/view_schema.rb",
    event_handlers: [
      InvoiceRecordEventHandler.new,
      InvoiceDashboardEventHandler.new
    ]
  )
  DB_CONFIG = YAML.load(ERB.new(File.read('db/database.yml')).result)
end
