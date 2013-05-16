# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open-uri'

u = User.create!(name: "Admin User",
             email: "admin@stacktician.org",
             password: "password",
             password_confirmation: "password")

u.toggle!(:admin)
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
    p 'Failed to parse stack template'
    next
  end
  descr = j['Description']
  begin
    StackTemplate.create!(user_id:1, template_url: l, template_name: name, description: descr, body: blob, category: 'General', public: true)
  rescue
      p 'Failed to create stack template'
      puts $!.inspect, $@
      next
  end
end

