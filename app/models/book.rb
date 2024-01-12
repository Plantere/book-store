class Book < ApplicationRecord
  has_many :genres dependent: :destroy
  belongs_to :authors
  belongs_to :publishers
  belongs_to :order_details
  belongs_to :book_images
end
