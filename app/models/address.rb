class Address < ApplicationRecord
  has_many :user, dependent: :destroy
  belongs_to :order
end
