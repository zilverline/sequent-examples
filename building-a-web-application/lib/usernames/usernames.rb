class Usernames < Sequent::AggregateRoot
  class UsernameAlreadyRegistered < StandardError; end

  # We can generate and hardcode the UUID since there is only one instance
  ID = "85507d60-8645-4a8a-bdb8-3a9c86a0c635"

  def self.instance(id = ID)
    Sequent.aggregate_repository.load_aggregate(id)
  rescue Sequent::Core::AggregateRepository::AggregateNotFound
    usernames = Usernames.new(id)
    Sequent.aggregate_repository.add_aggregate(usernames)
    usernames
  end

  def initialize(id)
    super(id)
    apply UsernamesCreated
  end

  def add(username)
    fail UsernameAlreadyRegistered if @usernames.include?(username.downcase)

    apply UsernameAdded, username: username
  end

  on UsernamesCreated do
    @usernames = Set.new
  end

  on UsernameAdded do |event|
    @usernames << event.username.downcase
  end
end
