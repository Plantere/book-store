FactoryBot.define do
  factory :order_detail do
    price { 15.99 }
    quantity { 1 }
    association :order, factory: :order
    association :book, factory: :book
  end
end 