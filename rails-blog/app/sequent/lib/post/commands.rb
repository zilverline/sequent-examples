class AddPost < Sequent::Command
  attrs author: String, title: String, content: String
  validates :title, presence: true,
                    length: { minimum: 5 }
end
