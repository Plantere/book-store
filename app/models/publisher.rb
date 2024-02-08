class Publisher < ApplicationRecord
  validates :name, presence: true, uniqueness:  true
  has_many :book, dependent: :destroy
end
