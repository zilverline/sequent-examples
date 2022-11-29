module Post
  class PostCommandHandler < Sequent::CommandHandler
    on AddPost do |command|
      repository.add_aggregate Post.new(command)
    end

    on DestroyPost do |command|
      do_with_aggregate(command, Post) do |post|
        post.destroy
      end
    end
  end
end
