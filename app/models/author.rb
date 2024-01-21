class Author < ApplicationRecord
  validates :full_name, :birth_date, presence: true

  has_many :book, dependent: :destroy
end
