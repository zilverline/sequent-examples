require './db/migrations'

Sequent.configure do |config|
  config.migrations_class_name = 'Migrations'

  config.command_handlers = [
    PostCommandHandler,
    AuthorCommandHandler,
  ].map(&:new)

  config.event_handlers = [
    PostProjector,
    AuthorProjector
  ].map(&:new)
end
