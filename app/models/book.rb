class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher
end
