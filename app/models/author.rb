class Author < ApplicationRecord
  validates :full_name, :birth_date, presence: true

  validates :full_name, uniqueness: {scope: :birth_date}

  has_many :book, dependent: :destroy
end
