class PostAdded < Sequent::Event
end

class PostAuthorChanged < Sequent::Event
  attrs author_aggregate_id: String
end

class PostTitleChanged < Sequent::Event
  attrs title: String
end

class PostContentChanged < Sequent::Event
  attrs content: String
end

class PostPublished < Sequent::Event
  attrs publication_date: Date
end
