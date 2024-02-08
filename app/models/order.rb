class Order < ApplicationRecord
  validates :price, :transaction_id, presence: true
  
  belongs_to :user
  belongs_to :address
  has_many :order_detail, dependent: :destroy
end
