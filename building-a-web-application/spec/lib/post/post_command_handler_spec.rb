require 'spec_helper'
require_relative '../../../lib/post'

describe PostCommandHandler do
  let(:aggregate_id) { Sequent.new_uuid }
  let(:author_aggregate_id) { Sequent.new_uuid }

  before :each do
    Sequent.configuration.command_handlers = [PostCommandHandler.new]
  end

  it 'creates a post' do
    when_command AddPost.new(aggregate_id: aggregate_id, author_aggregate_id: author_aggregate_id, title: 'My first blogpost', content: 'Hello World!')
    then_events(
      PostAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
      PostAuthorChanged.new(aggregate_id: aggregate_id, sequence_number: 2, author_aggregate_id: author_aggregate_id),
      PostTitleChanged,
      PostContentChanged
    )
  end

  it 'publishes a post' do
    given_events PostAdded.new(aggregate_id: aggregate_id, sequence_number: 1)

    when_command PublishPost.new(aggregate_id: aggregate_id, publication_date: Date.current.to_s)
    then_events(
      PostPublished.new(aggregate_id: aggregate_id, sequence_number: 1, publication_date: Date.current.to_s)
    )
  end
end
