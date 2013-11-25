FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"
    api_key "foo"
    sec_key "bar"
    cs_api_key "baz"
    cs_sec_key "blah"

    factory :admin do
       admin true
    end
  end

  factory :stack_template do
    template_name Faker::Lorem.sentence(1)
    user
  end

  factory :stack do
    stack_name Faker::Lorem.sentence(1)
    stack_id "foo"
    status "CREATE_COMPLETE"
    description Faker::Lorem.sentence(3)
    created_at 2.days.ago
    updated_at 1.day.ago
    user
    #stack_template
  end

  factory :stack_resource do
    logical_id "foo"
    physical_id "bar"
    status "CREATE_COMPLETE"
    description Faker::Lorem.sentence(3)
    typ "baz"
    created_at 2.days.ago + 4.hours
    updated_at 1.day.ago + 2.hours
    stack
  end

  factory :stack_parameter do
    param_name "foop"
    param_value "barp"
    created_at 2.days.ago + 2.hours
    updated_at 1.day.ago + 1.hour
    stack
  end

  factory :stack_output do
    key "abcd"
    value "1234"
    descr Faker::Lorem.sentence(3)
    created_at 2.days.ago + 5.hours
    updated_at 1.day.ago + 3.hours
    stack
  end
end
