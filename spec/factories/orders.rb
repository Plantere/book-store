FactoryBot.define do
  factory :order do
    transaction_id { "RANDOM_TRANSACTION_ID" }
    price { 15.99 }
    association :address, factory: :address, strategy: :build
    association :user, factory: :user, strategy: :build
  end
end 