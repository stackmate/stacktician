#!/usr/bin/env ruby
require_relative 'sm-utils'
require 'optparse'
require 'json'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: sm-list-stack-outputs.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"
   opts.on(:REQUIRED, "--id ID", String, "ID of stack to be listed") do |id|
     options[:id] = id
   end
  options[:conf] = 'config.yml'
  opts.on("--config CONF",String, "Path to YAML config file. defaults to config.yml") do |conf|
    options[:conf] = conf
  end
  opts.on("-h", "--help", "Show this message")  do
    puts opts
    exit
  end
end

begin
  opt_parser.parse!(ARGV)
  raise "Missing ID" if options[:id].nil?
rescue => e
  puts e.message.capitalize
  puts opt_parser.help()
  exit 1
end

@client = StackticianApi.new(options[:conf])
url = "stacks/" + options[:id] +"/outputs"
json = @client.make_get_request(url,{'id'=>options[:id]})
p json
