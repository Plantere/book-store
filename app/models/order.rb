class Order < ApplicationRecord
  has_many :user, dependent: :destroy
  has_many :address, dependent: :destroy
  belongs_to :order_detail
end
