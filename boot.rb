ENV["RACK_ENV"] ||= "development"
require "bundler"
Bundler.setup

require_relative 'db/database'

Database::establish_connection(ENV["RACK_ENV"]) do |config|
  config['schema_search_path'] = "public"
end
Database::init ENV["RACK_ENV"]
Database::set_schema_search_path_to_current_version ENV["RACK_ENV"]
