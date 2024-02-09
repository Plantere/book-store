FactoryBot.define do
  factory :author do
    full_name { 'George Orwell' }
    birth_date { 49.year.ago }
  end
end 