FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :gram do
    sequence :message do |m|
    "Hello! This is dummy message No. #{m}."
    end
    association :user
  end
  
end