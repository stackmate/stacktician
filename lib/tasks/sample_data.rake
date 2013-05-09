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

    Dir.glob('../../stackmate/templates/*.template') do |t|
      name = File.basename(t, '.template')
      name = name.split('_').join(' ').split('-').join(' ')
      blob = File.read(t)
      j = JSON.parse(blob)
      descr = j['Description']
      StackTemplate.create!(user_id:1, template_name: name, description: descr, body: blob, category: 'General', public: true)
    end

    users = User.all(limit: 6)
    5.times do
     users.each { |user| name = Faker::Lorem.sentence(1); user.stacks.create!(stack_name: name, stack_template_id:1) }
    end

  end
end
