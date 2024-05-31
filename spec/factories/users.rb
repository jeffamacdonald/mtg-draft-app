FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "jeff#{n}@example.com" }
    password  { "123456" }
    sequence(:username) { |n| "jeff#{n}" }
    phone { "5555555555" }
    secret_key { "test_secret" }
  end
end
