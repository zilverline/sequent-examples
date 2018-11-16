class AuthorRecord < ActiveRecord::Base
  has_many :post_records, foreign_key: :author_aggregate_id, primary_key: :aggregate_id
end
