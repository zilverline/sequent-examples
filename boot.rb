ENV["RACK_ENV"] ||= "development"
require "bundler"
Bundler.setup

require_relative 'db/database'
require_relative 'db/version'

database = Database.for_active_record(ENV["RACK_ENV"], SCHEMA_VERSION)
database.establish_connection do |config|
  config['schema_search_path'] = "public"
end
database.init
database.set_schema_search_path_to_current_version
