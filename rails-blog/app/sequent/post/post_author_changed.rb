module Post
  class PostAuthorChanged < Sequent::Event
    attrs author: String
  end
end