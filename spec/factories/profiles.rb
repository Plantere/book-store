FactoryBot.define do
  factory :profile do
    first_name { "John" }
    last_name { "Doe" }
    birth_date { 21.years.ago }
    association :user, factory: :user, strategy: :build
  end
end 