class OrderDetail < ApplicationRecord
  has_many :books dependent: :destroy
  has_many :orders dependent: :destroy
end
