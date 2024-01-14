class Genre < ApplicationRecord
  has_many :book, dependent: :destroy
end
