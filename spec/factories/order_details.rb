FactoryBot.define do
  factory :order_detail do
    price { 15.99 }
    quantity { 1 }
    association :order, factory: :order, strategy: :build
    association :book, factory: :book, strategy: :build
  end
end 