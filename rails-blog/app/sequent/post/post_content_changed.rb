module Post
  class PostContentChanged < Sequent::Event
    attrs content: String
  end
end