require 'spec_helper'

describe PostCommandHandler do
  let(:aggregate_id) { Sequent.new_uuid }

  before :each do
    Sequent.configuration.command_handlers = [PostCommandHandler.new]
  end

  it 'creates a post' do
    when_command AddPost.new(aggregate_id: aggregate_id, author_aggregate_id: 'ben', title: 'My first blogpost', content: 'Hello World!')
    then_events(
      PostAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
      PostAuthorChanged.new(aggregate_id: aggregate_id, sequence_number: 2, author_aggregate_id: 'ben'),
      PostTitleChanged,
      PostContentChanged
    )
  end
end
