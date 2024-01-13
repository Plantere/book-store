class Book < ApplicationRecord
  has_many :genre, dependent: :destroy
  belongs_to :author
  belongs_to :publisher
  belongs_to :order_detail
  belongs_to :book_image
end
