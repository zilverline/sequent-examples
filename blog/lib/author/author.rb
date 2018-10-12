class Author < Sequent::AggregateRoot
  def initialize(command)
    super(command.aggregate_id)
    apply AuthorCreated
    apply AuthorNameSet, name: command.name
    apply AuthorEmailSet, email: command.email
  end

  on AuthorCreated do

  end

end
