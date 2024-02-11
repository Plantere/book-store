class Address < ApplicationRecord
  validates :name, :country, :state, :district, :number, :postal_code, :phone_number, :city, presence: true
  validates :is_default, inclusion: [true, false]
  
  belongs_to :user
  has_many :order, dependent: :destroy
end
