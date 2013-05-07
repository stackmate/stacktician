namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@stacktician.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    9.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@stacktician.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    users = User.all(limit: 6)
    5.times do
     users.each { |user| name = Faker::Lorem.sentence(1); user.stacks.create!(stack_name: name) }
    end
  end
end
