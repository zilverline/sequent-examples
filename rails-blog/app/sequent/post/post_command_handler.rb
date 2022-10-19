module Post
  class PostCommandHandler < Sequent::CommandHandler
    on AddPost do |command|
      repository.add_aggregate Post.new(command)
    end
  end
end