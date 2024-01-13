class BookImage < ApplicationRecord
  has_many :book, dependent: :destroy
end
