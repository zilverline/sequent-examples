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
    require_relative 'db/version'
    database = Database.for_active_record(current_env, SCHEMA_VERSION)
    database.establish_connection
    database.drop_view_schema(SCHEMA_VERSION) if database.schema_exists("view_#{SCHEMA_VERSION}")
    Rake::Task["sequent:upgrade"].execute
  end

  desc 'Upgrade sequent to new version'
  task :upgrade do
    require_relative 'db/version'
    database = Database.for_active_record current_env, SCHEMA_VERSION
    database.establish_connection
    begin

      if database.schema_exists("event_store")
        database.migrate
      else
        database.load_event_store(File.expand_path("../db/event_store.rb", __FILE__))
      end

      unless database.schema_exists("view_#{SCHEMA_VERSION}")
        database.load_view(File.expand_path("../db/view_schema.rb", __FILE__))
        database.init
        ViewModel.rebuild_view_model_from_events
      end
    ensure
      database.clear_active_connections!
    end

  end
end


