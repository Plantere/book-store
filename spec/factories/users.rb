FactoryBot.define do
  factory :user do
    username { 'John_example' }
    password  { 'JohnIsAmazing' }
    email { 'John@example.com' }
    status { 1 }
    user_type { 1 }
  end
end 