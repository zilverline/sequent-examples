require_relative '../../spec_helper'
require_relative '../../../lib/author'
require_relative '../../../lib/usernames'

describe AuthorCommandHandler do
  before :each do
    Sequent.configuration.command_handlers = [AuthorCommandHandler.new]
  end

  context AddAuthor do
    let(:user_aggregate_id) { Sequent.new_uuid }
    let(:email) { 'ben@sequent.io' }

    it "creates a user when valid input" do
      when_command AddAuthor.new(aggregate_id: user_aggregate_id, name: "Ben", email: email)
      then_events UsernamesCreated.new(aggregate_id: Usernames::ID, sequence_number: 1),
                  UsernameAdded.new(aggregate_id: Usernames::ID, username: email, sequence_number: 2),
                  AuthorCreated.new(aggregate_id: user_aggregate_id, sequence_number: 1),
                  AuthorNameSet,
                  AuthorEmailSet.new(aggregate_id: user_aggregate_id, email: email, sequence_number: 3)
    end

    it "fails if the username already exists" do
      given_events UsernamesCreated.new(aggregate_id: Usernames::ID, sequence_number: 1),
                   UsernameAdded.new(aggregate_id: Usernames::ID, username: email, sequence_number: 2)
      expect {
        when_command AddAuthor.new(
          aggregate_id: Sequent.new_uuid,
          name: 'kim',
          email: 'ben@sequent.io'
        )
      }.to raise_error Usernames::UsernameAlreadyRegistered
    end

    it "ignores case in usernames" do
      given_events UsernamesCreated.new(aggregate_id: Usernames::ID, sequence_number: 1),
                   UsernameAdded.new(aggregate_id: Usernames::ID, username: email, sequence_number: 2)
      expect {
        when_command AddAuthor.new(
          aggregate_id: Sequent.new_uuid,
          name: 'kim',
          email: 'BeN@SeQuEnT.io'
        )
      }.to raise_error Usernames::UsernameAlreadyRegistered
    end

  end

end
