class Address < ApplicationRecord
  has_many :users dependent: :destroy
  belongs_to :orders
end
