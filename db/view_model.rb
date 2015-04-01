require_relative 'database'
require 'parallel'
require 'active_record'
require_relative '../invoices/records'
require_relative '../invoices/event_handlers'

class ViewModel
  def self.rebuild_view_model_from_events
    all_organization_ids = EventRecord.pluck(:organization_id).uniq
    puts "rebuilding #{all_organization_ids.size} organizations in 2 processes"
    database = Database.for_active_record(ENV["RACK_ENV"], SCHEMA_VERSION)
    database.set_schema_search_path_to_current_version
    Parallel.each(all_organization_ids, in_processes: 2) do |id|
      session = Sequent::Core::RecordSessions::ReplayEventsSession.new
      database.reconnect!
      event_store = Sequent::Core::TenantEventStore.new(
        Sequent::Core::EventStoreConfiguration.new(
          EventRecord,
          [InvoiceRecordEventHandler, InvoiceDashboardEventHandler].map(&:new)
        )
      )
      begin
        event_store.replay_events_for(id)
        session.commit if session.respond_to? :commit
      rescue => e
        puts "Replaying failed for organization: #{id}"
        puts "#{e.to_s}\n#{e.backtrace.join("\n")}"
        raise e
      ensure
        database.clear_active_connections!
      end

    end
  end
end
