class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_detail, dependent: :destroy
end
