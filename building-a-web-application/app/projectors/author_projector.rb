require_relative '../records/author_record'
require_relative '../../lib/author/events'

class AuthorProjector < Sequent::Projector
  manages_tables AuthorRecord

  on AuthorCreated do |event|
    create_record(
      AuthorRecord,
      aggregate_id: event.aggregate_id
    )
  end

  on AuthorNameSet do |event|
    update_all_records(
      AuthorRecord,
      { aggregate_id: event.aggregate_id },
      event.attributes.slice(:name)
    )
  end

  on AuthorEmailSet do |event|
    update_all_records(
      AuthorRecord,
      { aggregate_id: event.aggregate_id },
      event.attributes.slice(:email)
    )
  end
end
