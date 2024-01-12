class Profile < ApplicationRecord
  has_one :users dependent: :destroy
end
