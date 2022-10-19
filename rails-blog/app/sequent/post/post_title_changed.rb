module Post
  class PostTitleChanged < Sequent::Event
    attrs title: String
  end
end