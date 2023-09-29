module Post
  class Post < Sequent::AggregateRoot
    def initialize(command)
      super(command.aggregate_id)
      apply Events::PostAdded
      apply Events::PostAuthorChanged, author: command.author
      apply Events::PostTitleChanged, title: command.title
      apply Events::PostContentChanged, content: command.content
    end

    def destroy
      apply Events::PostDestroyed
    end

    on Events::PostAdded do
    end

    on Events::PostAuthorChanged do |event|
      @author = event.author
    end

    on Events::PostTitleChanged do |event|
      @title = event.title
    end

    on Events::PostContentChanged do |event|
      @content = event.content
    end

    on Events::PostDestroyed do
    end
  end
end
