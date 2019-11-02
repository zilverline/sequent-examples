# frozen_string_literal: true

class Article < ApplicationRecord
  validates :title, presence: true,
                    length: { minimum: 5 }
end
