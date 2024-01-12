class User < ApplicationRecord
  belongs_to :profiles
  belongs_to :addresses
  belongs_to :telephones
end
