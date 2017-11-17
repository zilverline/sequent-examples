ENV["RACK_ENV"] ||= "development"
require "bundler"
Bundler.setup

require 'sequent/support'
require_relative 'invoicing_app'
require_relative 'initializers/sequent'

Sequent::Support::Database.establish_connection(InvoicingApp::DB_CONFIG[ENV["RACK_ENV"]])
