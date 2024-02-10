FactoryBot.define do
  factory :user do
    username { 'john_example' }
    password  { 'JohnIsAmazing' }
    email { 'john@example.com' }
    status { 1 }
    user_type { 1 }
  end
end 