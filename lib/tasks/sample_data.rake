require 'open-uri'

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


    doc = Nokogiri::HTML(open("http://aws.amazon.com/cloudformation/aws-cloudformation-templates"))
    links = []
    doc.xpath('//a[@href]').each do |link|
      l = link['href'] if link['href'].end_with? 'template' and !link['href'].include? '|'
      u = URI(l.to_s)
      ['WordPress', 'VPC', 'wordpress', 'vpc', 'Joomla', 'Drupal', 'Gollum', 'Tracks', 'Redmine', 'Insoshi'].each do |w|
          if u.path.include? w
             links << l.to_s
             break
          end
      end
    end

    links.each do |l|
      u = URI(l)
      name = (u.path.split '/')[2]
      name = name.split('_').join(' ').split('-').join(' ').gsub('.template', '')
      p name
      next if name.length > 49
      blob = open(l).read()
      begin
        j = JSON.parse(blob)
      rescue
        next
      end
      descr = j['Description']
      begin
        StackTemplate.create!(user_id:1, template_url: l, template_name: name, description: descr, body: blob, category: 'General', public: true)
      rescue
          next
      end
    end

    users = User.all(limit: 6)
    5.times do
     users.each { |user| name = Faker::Lorem.sentence(1); user.stacks.create!(stack_name: name, stack_template_id:1) }
    end

  end
end
