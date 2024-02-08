class BookImage < ApplicationRecord
  validates :path, presence: true
  validates :is_default, inclusion: [true, false]

  belongs_to :book

  scope :get_default_or_first, -> {
    record = where(is_default: true).first
    record.present? ? record[:path] : nil
  }
end
