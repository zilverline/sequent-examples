class AddPost < Sequent::Command
  attrs author_aggregate_id: String, title: String, content: String
  validates_presence_of :author_aggregate_id, :title, :content
end


class PublishPost < Sequent::Command
  attrs publication_date: DateTime
  validates_presence_of :publication_date
end
