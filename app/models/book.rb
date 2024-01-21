class Book < ApplicationRecord
  validates :name, :description, :stock_quantity, :price, presence: true
  validates :stock_quantity, :price, numericality: true
  
  belongs_to :publisher
  belongs_to :author
  belongs_to :genre
  has_many :order_detail, dependent: :destroy
  has_many :book_image, dependent: :destroy
end
