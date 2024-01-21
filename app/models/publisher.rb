class Publisher < ApplicationRecord
  validates :name, presence: true

  has_many :book, dependent: :destroy
end
