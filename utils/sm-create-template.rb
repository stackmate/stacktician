#!/usr/bin/env ruby
require_relative 'sm-utils'
require 'optparse'
require 'json'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: sm-create-template.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"
  opts.on(:REQUIRED, "--template FILE", String, "Path of template JSON file") do |f|
    options[:file] = f
  end
  opts.on(:REQUIRED, "--name NAME", String, "Name of template to create") do |name|
    options[:name] = name
  end
  options[:conf] = 'config.yml'
  opts.on("--config CONF",String, "Path to YAML config file. defaults to config.yml") do |conf|
    options[:conf] = conf
  end
  options[:description] = {}
  params = {}
  opts.on("--description STRING",String, "Description of template") do |d|
    options[:description] = d
  end
  opts.on("-h", "--help", "Show this message")  do
    puts opts
    exit
  end
end

begin
  opt_parser.parse!(ARGV)
  raise "Missing template file" if options[:file].nil?
  raise "Unable to read template file" if !File.exist?(options[:file])
  raise "Missing template name or description" if (options[:name].nil? || options[:description].nil?)
rescue => e
  puts e.message.capitalize
  puts opt_parser.help()
  exit 1
end

@client = StackticianApi.new(options[:conf])
params = {}
params = params.merge({'name'=>options[:name]}).merge({'description' => options[:description]})
json = @client.make_post_request("templates",params,options[:file])
p json
