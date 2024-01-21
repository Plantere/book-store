class Genre < ApplicationRecord
  validates :name, :description, presence: true

  has_many :book, dependent: :destroy
end
