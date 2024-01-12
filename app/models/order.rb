class Order < ApplicationRecord
  has_many :users dependent: :destroy
  has_many :addresses dependent: :destroy
  belongs_to :order_details
end
