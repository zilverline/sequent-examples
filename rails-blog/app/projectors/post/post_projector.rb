module Post
  class PostProjector < Sequent::Projector
    manages_tables PostRecord

    on Events::PostAdded do |event|
      create_record(PostRecord, aggregate_id: event.aggregate_id)
    end

    on Events::PostAuthorChanged do |event|
      update_all_records(PostRecord, { aggregate_id: event.aggregate_id }, event.attributes.slice(:author))
    end

    on Events::PostTitleChanged do |event|
      update_all_records(PostRecord, { aggregate_id: event.aggregate_id }, event.attributes.slice(:title))
    end

    on Events::PostContentChanged do |event|
      update_all_records(PostRecord, { aggregate_id: event.aggregate_id }, event.attributes.slice(:content))
    end

    on Events::PostDestroyed do |event|
      delete_all_records(PostRecord, event.attributes.slice(:aggregate_id))
    end
  end
end