class Order < ApplicationRecord
  validates :price, numericality: true, presence: true

  belongs_to :user
  belongs_to :address
  has_many :order_detail, dependent: :destroy
end
