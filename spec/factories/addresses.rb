FactoryBot.define do
  factory :address do
    name { "Address 1" }
    country { "United States" }
    state { "New York" }
    street { "West 42nd Street" }
    district { "Manhattan" }
    city { "New York" }
    complement { "Madame Toussauds" }
    postal_code { "10036" }
    number { 234 }
    phone_number { "4383828382392" }
    is_default { true }
    association :user, factory: :user, strategy: :build
  end
end 