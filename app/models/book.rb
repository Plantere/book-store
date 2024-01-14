class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :author
  belongs_to :genre
  has_many :order_detail, dependent: :destroy
  has_many :book_image, dependent: :destroy
end
