class OrderDetail < ApplicationRecord
  has_many :book, dependent: :destroy
  has_many :order, dependent: :destroy
end
