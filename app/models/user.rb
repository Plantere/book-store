class User < ApplicationRecord
  has_secure_password
  has_many :address, dependent: :destroy
  has_many :telephone, dependent: :destroy
  has_many :order, dependent: :destroy
  has_one :profile, dependent: :destroy
end
