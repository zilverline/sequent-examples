module Projectors
  class PostProjector < Sequent::Projector
    manages_tables Projections::PostRecord

    on Post::PostAdded do |event|
      create_record(Projections::PostRecord, aggregate_id: event.aggregate_id)
    end

    on Post::PostAuthorChanged do |event|
      update_all_records(Projections::PostRecord, { aggregate_id: event.aggregate_id }, event.attributes.slice(:author))
    end

    on Post::PostTitleChanged do |event|
      update_all_records(Projections::PostRecord, { aggregate_id: event.aggregate_id }, event.attributes.slice(:title))
    end

    on Post::PostContentChanged do |event|
      update_all_records(Projections::PostRecord, { aggregate_id: event.aggregate_id }, event.attributes.slice(:content))
    end

    on Post::PostDestroyed do |event|
      delete_all_records(Projections::PostRecord, event.attributes.slice(:aggregate_id))
    end
  end
end
