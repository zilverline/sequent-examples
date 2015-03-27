require "bundler"
Bundler.setup

require_relative 'db/database'
require_relative 'db/view_model'

def current_env
  ENV["RACK_ENV"] ||= "development"
end

namespace :db do
  create_database = ->(user, password, database) {
    puts "Creating user #{user} and database #{database}"
    `createuser #{user} -R -S -D`
    `createdb -E 'UTF8' -O #{user} #{database}`
    `psql -d #{database} -c "ALTER USER #{user} PASSWORD '#{password}'"`
    puts "Database #{database} and user #{user} created"
  }

  desc "Create the dev database"
  task :create do
    create_database["sequent", "sequent", "sequent_db"]
  end

  desc "Drop the dev and spec users and databases"
  task :drop do
    puts "Dropping development database and user"
    `dropdb sequent_db`
    `dropuser sequent`
    puts "Database and user dropped"
  end

end

namespace :sequent do

  desc 'rebuilds the view model from events'
  task :rebuild do
    Database.establish_connection(current_env)
    require_relative 'db/version'
    Database.drop_view_schema(SCHEMA_VERSION) if Database.schema_exists("view_#{SCHEMA_VERSION}")
    Rake::Task["sequent:upgrade"].execute
  end

  desc 'Upgrade sequent to new version'
  task :upgrade do
    Database.establish_connection(current_env)
    begin

      if Database.schema_exists("event_store")
        Database.migrate current_env
      else
        Database.load_freemle
      end

      unless Database.schema_exists("view_#{SCHEMA_VERSION}")
        Database.load_view
        Database.init ENV["RACK_ENV"]
        ViewModel.rebuild_view_model_from_events
      end
    ensure
      ActiveRecord::Base.clear_active_connections!
    end

  end
end


