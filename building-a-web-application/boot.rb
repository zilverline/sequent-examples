ENV['RACK_ENV'] ||= 'development'

require 'sequent'
require './app/database'
Database.establish_connection

require './app/web'
