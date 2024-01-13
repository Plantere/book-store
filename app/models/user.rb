class User < ApplicationRecord
  belongs_to :profile
  belongs_to :address
  belongs_to :telephone
end
