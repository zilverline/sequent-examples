class Post < Sequent::AggregateRoot
  def initialize(command)
    super(command.aggregate_id)
    apply PostAdded
    apply PostAuthorChanged, author_aggregate_id: command.author_aggregate_id
    apply PostTitleChanged, title: command.title
    apply PostContentChanged, content: command.content
  end

  class PostAlreadyPublishedError < StandardError; end

  def publish(publication_date)
    fail PostAlreadyPublishedError if @publication_date.present?
    apply PostPublished, publication_date: publication_date
  end

  def edit(title, content)
    apply PostTitleChanged, title: title
    apply PostContentChanged, content: content
  end

  on PostAdded do
  end

  on PostAuthorChanged do |event|
    @author_aggregate_id = event.author_aggregate_id
  end

  on PostTitleChanged do |event|
    @title = event.title
  end

  on PostContentChanged do |event|
    @content = event.content
  end

  on PostPublished do |event|
    @publication_date = event.publication_date
  end
end
