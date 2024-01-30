class Address < ApplicationRecord
  validates :name, :country, :state, :district, :number, :postal_code, :phone_number presence: true
  
  belongs_to :user
  has_many :order, dependent: :destroy
end
