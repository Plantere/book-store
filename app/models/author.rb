class Author < ApplicationRecord
  has_many :book, dependent: :destroy
end
