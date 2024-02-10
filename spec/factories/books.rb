FactoryBot.define do
  factory :book do
    name { "1984" }
    description { "1984” is a dystopian novel by George Orwell published in 1949. The novel is set in Airstrip One, a province of the superstate Oceania in a world of perpetual war, omnipresent government surveillance, and public manipulation" }
    stock_quantity { 20 }
    price { 15.99 }
    association :author, factory: :author, strategy: :build
    association :genre, factory: :genre, strategy: :build
    association :publisher, factory: :publisher, strategy: :build
  end
end 