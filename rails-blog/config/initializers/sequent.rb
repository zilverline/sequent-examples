require_relative '../../db/sequent_migrations'

Rails.application.reloader.to_prepare do
  Sequent.configure do |config|
    config.migrations_class_name = 'SequentMigrations'
    config.enable_autoregistration = true
    config.event_store_cache_event_types = !Rails.env.development?

    config.database_config_directory = 'config'

    # this is the location of your sql files for your view_schema
    config.migration_sql_files_directory = 'db/sequent'
  end
end
