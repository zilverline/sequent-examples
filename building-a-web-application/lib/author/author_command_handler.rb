class AuthorCommandHandler < Sequent::CommandHandler
  on AddAuthor do |command|
    Usernames.instance.add(command.email)
    repository.add_aggregate(Author.new(command))
  end
end
