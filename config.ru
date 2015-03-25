# config.ru (run with rackup)
require_relative 'boot'
require_relative 'invoicing_app'
run InvoicingApp
