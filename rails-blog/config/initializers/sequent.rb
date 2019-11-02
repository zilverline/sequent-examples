require_relative '../sequent_migrations'
require_relative '../../app/sequent/lib/post'

Sequent.configure do |config|
  config.migrations_class_name = 'SequentMigrations'

  config.command_handlers = [
    PostCommandHandler.new,
  ]

  config.event_handlers = [
    PostProjector.new,
  ]

  config.logger = Logger.new(STDOUT)

  config.database_config_directory = 'config'
  config.migration_sql_files_directory = 'db/sequent'
end
