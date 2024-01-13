class Publisher < ApplicationRecord
  has_many :book, dependent: :destroy
end
