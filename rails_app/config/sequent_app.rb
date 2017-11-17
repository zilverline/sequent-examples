require 'sequent'
require 'sequent/support'
require_relative '../app/lib/invoice_projector'

module SequentApp
  VERSION = 1

  VIEW_PROJECTION = Sequent::Support::ViewProjection.new(
    name: "view",
    version: VERSION,
    definition: "db/view_schema.rb",
    event_handlers: [
      InvoiceProjector.new
    ]
  )
  DB_CONFIG = YAML.load(ERB.new(File.read('config/database.yml')).result)
end
