class Telephone < ApplicationRecord
  validates :name, :area_code, :phone_number, presence: true
  belongs_to :user
end
