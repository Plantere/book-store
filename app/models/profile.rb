class Profile < ApplicationRecord
  validates :first_name, :last_name, :birth_date, presence: true
  belongs_to :user
end
