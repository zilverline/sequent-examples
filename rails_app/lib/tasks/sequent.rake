namespace :sequent do
  begin
    require 'sequent/rake/tasks'
    require_relative '../../config/sequent_app'
    Sequent::Rake::Tasks.new({
      db_config_supplier: SequentApp::DB_CONFIG,
      view_projection: SequentApp::VIEW_PROJECTION,
      event_store_schema: 'event_store',
      environment: ENV['RACK_ENV'] || 'development'
    }).register!
  rescue LoadError
    fail 'im jere'
    puts 'Sequent tasks are not available'
  end
end
