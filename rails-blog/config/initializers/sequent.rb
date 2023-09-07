require_relative '../../db/sequent_migrations'

Rails.application.reloader.to_prepare do
  Sequent.configure do |config|
    config.migrations_class_name = 'SequentMigrations'

    config.command_handlers = [
      Post::PostCommandHandler.new,
    ]

    config.event_handlers = [
      Post::PostProjector.new,
    ]

    config.logger = Logger.new(STDOUT)

    config.database_config_directory = 'config'
    config.migration_sql_files_directory = 'db/sequent'
  end
end
