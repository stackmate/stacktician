FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
       admin true
    end
  end

  factory :stack do
    stack_name Faker::Lorem.sentence(1)
    user
  end

  factory :stack_template do
    template_name Faker::Lorem.sentence(1)
    user
  end
end
