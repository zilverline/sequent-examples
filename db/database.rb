#TODO: Move to sequent and clean up

require_relative 'version'
require 'yaml'
require 'erb'
require 'active_record'
require 'sequent'

module Database
  class << self

    def init(env)
      unless schema_exists("view_#{SCHEMA_VERSION}")
        $stderr.puts "view schema version #{SCHEMA_VERSION} does not exists, run `rake upgrade` to upgrade to the latest view schema"
        exit 1
      end

      set_schema_search_path_to_version env, SCHEMA_VERSION
    end

    def schema_exists(schema_name)
      set_schema_search_path "public"
      execute_sql("SELECT * FROM information_schema.schemata WHERE schema_name = '#{schema_name}'").count == 1
    end

    def database_config(env)
      @config ||= YAML.load(ERB.new(File.read('db/database.yml')).result)[env]
    end

    def establish_connection(env)
      config = database_config(env)
      yield(config) if block_given?
      ActiveRecord::Base.establish_connection config
    end

    def new_version
      SCHEMA_VERSION
    end

    ##
    # See Sequent::Migrations::MigrateEvents
    #
    # @param env The string representing the current environment. E.g. "development", "production"
    #
    def migrate(env)
      current_version = self.current_version
      migrations = Sequent::Migrations::MigrateEvents.new(env)

      migrations.execute_migrations current_version, new_version do
        ActiveRecord::Base.clear_active_connections!
      end

    end

    def current_version
      result = all_view_versions
      result.count > 0 ? sorted_view_versions(result).last : 0
    end

    # Returns the previous version. Parameter denotes how many versions ago.
    def previous_version(ago = 0)
      unless @previous_version
        result = all_view_versions
        @previous_version = if result.count < 2
                              0
                            else
                              versions = sorted_view_versions(result)
                              versions[versions.length - (1 + ago)]
                            end
      end
      @previous_version
    end

    def all_view_versions
      ActiveRecord::Base.connection.execute("SELECT schema_name FROM information_schema.schemata WHERE schema_name like 'view_%'")
    end

    def sorted_view_versions(versions)
      versions.map { |r| r["schema_name"].gsub("view_", "").to_i }.sort
    end

    def connection
      ActiveRecord::Base.connection
    end

    def execute_sql(sql)
      connection.execute sql
    end

    def set_schema_search_path_to_current_version(env)
      set_schema_search_path_to_version(env, SCHEMA_VERSION)
    end

    def set_schema_search_path_to_version(env, version)
      ActiveRecord::Base.clear_active_connections!

      establish_connection(env) do |config|
        config['schema_search_path'] = "event_store, view_#{version}, public"
      end

    end

    def set_schema_search_path(path)
      connection.schema_search_path = "#{path}"
    end

    def load_view
      self.load_schema(File.expand_path("../view_schema.rb", __FILE__), "view_#{SCHEMA_VERSION}")
    end

    def load_freemle
      self.load_schema(File.expand_path("../event_store.rb", __FILE__), "event_store")
    end

    def load_schema(filename, schema_name)
      ActiveRecord::Schema.verbose = false
      if File.exists?(filename)
        unless Database::schema_exists schema_name
          Database::execute_sql "CREATE SCHEMA #{schema_name} AUTHORIZATION #{ActiveRecord::Base.connection_config[:username]}"
        end
        Database::set_schema_search_path schema_name
        load(filename)
      else
        abort %{#{filename} doesn't exist}
      end
    end

    def drop_view_schema(version)
      set_schema_search_path "public"
      execute_sql("drop schema view_#{version} cascade")
    end



  end

end
