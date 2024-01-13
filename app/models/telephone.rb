class Telephone < ApplicationRecord
  has_many :user, dependent: :destroy
end
