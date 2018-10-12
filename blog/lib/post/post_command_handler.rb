class PostCommandHandler < Sequent::CommandHandler
  on AddPost do |command|
    repository.add_aggregate Post.new(command)
  end

  on PublishPost do |command|
    do_with_aggregate(command, Post) do |post|
      post.publish(command.publication_date)
    end
  end
end
