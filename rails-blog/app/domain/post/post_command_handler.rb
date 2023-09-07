module Post
  class PostCommandHandler < Sequent::CommandHandler
    on Commands::AddPost do |command|
      repository.add_aggregate Post.new(command)
    end

    on Commands::DestroyPost do |command|
      do_with_aggregate(command, Post) do |post|
        post.destroy
      end
    end
  end
end
