require 'yaml'
require 'erb'
require 'active_record'
require 'sequent-sinatra'

class Database

  class ActiveRecordConnectionProvider
    def initialize(env)
      @env = env
    end

    def load_config
      @config ||= YAML.load(ERB.new(File.read('db/database.yml')).result)[@env]
    end

    def establish_connection
      config = load_config
      yield(config) if block_given?
      ActiveRecord::Base.establish_connection config
    end

    def execute(sql)
      ActiveRecord::Base.connection.execute(sql)
    end

    def reset_connections_to(version)
      ActiveRecord::Base.clear_active_connections!

      establish_connection do |config|
        config['schema_search_path'] = "event_store, view_#{version}, public"
      end
    end

    def set_schema_search_path(path)
      ActiveRecord::Base.connection.schema_search_path = "#{path}"
    end

    def before_load_schema
      ActiveRecord::Schema.verbose = false
    end

    def username
      ActiveRecord::Base.connection_config[:username]
    end

    def clear_active_connections!
      ActiveRecord::Base.clear_active_connections!
    end
  end

  def self.for_active_record(env, schema_version)
    new(env, schema_version, ActiveRecordConnectionProvider.new(env))
  end

  def initialize(env, schema_version, connection_provider)
    @env = env
    @connection_provider = connection_provider
    @schema_version = schema_version
  end

  def init
    unless schema_exists("view_#{@schema_version}")
      raise "view schema version #{@schema_version} does not exists, use #{Database}.load_view to create the latest view schema"
    end

    set_schema_search_path_to_version SCHEMA_VERSION
  end

  def schema_exists(schema_name)
    set_schema_search_path "public"
    execute_sql("SELECT * FROM information_schema.schemata WHERE schema_name = '#{schema_name}'").count == 1
  end

  def establish_connection(&block)
    @connection_provider.establish_connection(&block)
  end

  ##
  # See Sequent::Migrations::MigrateEvents
  #
  def migrate
    migrations = Sequent::Migrations::MigrateEvents.new(@env)

    migrations.execute_migrations current_version, @schema_version do
      ActiveRecord::Base.clear_active_connections!
    end

  end

  def drop_view_schema(version)
    set_schema_search_path "public"
    execute_sql("drop schema view_#{version} cascade")
  end

  def set_schema_search_path_to_current_version
    set_schema_search_path_to_version(@schema_version)
  end

  def load_view(view_schema_file)
    load_schema(view_schema_file, "view_#{@schema_version}")
  end

  def load_event_store(freemle_schema_file)
    load_schema(freemle_schema_file, "event_store")
  end

  def reconnect!
    ActiveRecord::Base.connection.reconnect!
  end

  def clear_active_connections!
    @connection_provider.clear_active_connections!
  end

  private

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
    execute_sql("SELECT schema_name FROM information_schema.schemata WHERE schema_name like 'view_%'")
  end

  def sorted_view_versions(versions)
    versions.map { |r| r["schema_name"].gsub("view_", "").to_i }.sort
  end

  def execute_sql(sql)
    @connection_provider.execute(sql)
  end

  def set_schema_search_path_to_version(version)
    @connection_provider.reset_connections_to(version)
  end

  def set_schema_search_path(path)
    @connection_provider.set_schema_search_path(path)
  end

  def load_schema(filename, schema_name)
    @connection_provider.before_load_schema

    if File.exists?(filename)
      unless schema_exists schema_name
        execute_sql "CREATE SCHEMA #{schema_name} AUTHORIZATION #{@connection_provider.username}"
      end
      set_schema_search_path schema_name
      load(filename)
    else
      raise %{#{filename} doesn't exist}
    end
  end


end
