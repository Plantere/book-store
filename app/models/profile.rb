class Profile < ApplicationRecord
  has_one :user, dependent: :destroy
end
