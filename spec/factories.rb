FactoryBot.define do
  factory :response do
    message "My Response to your Comment"
    association :user
    association :comment
  end
  
  factory :comment do
    message "My Comment"
    association :user
    association :gram
  end
  
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    sequence :fullname do |n|
      "Jane Doe \##{n}"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :gram do
    message "Hello!"
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png').to_s, 'image/png') }
    association :user
  end
end