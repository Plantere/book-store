class Telephone < ApplicationRecord
  has_many :users dependent: :destroy
end
