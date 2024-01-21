class OrderDetail < ApplicationRecord
  validates :price, :quantity, numericality: true, presence: true

  belongs_to :order
  belongs_to :book
end
