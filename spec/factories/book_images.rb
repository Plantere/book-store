FactoryBot.define do
  factory :book_image do
    path { "/storage/image/book_page.png" }
    is_default { true }
    association :book, factory: :book
  end
end 