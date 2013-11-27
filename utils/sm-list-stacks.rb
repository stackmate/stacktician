require_relative 'sm-utils'
require 'optparse'
require 'json'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: sm-list-stacks.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"
  # opts.on(:REQUIRED, "--id ID", String, "Path to the file that contains the template") do |f|
  #   options[:file] = f
  # end
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
rescue => e
  puts e.message.capitalize
  puts opt_parser.help()
  exit 1
end

@client = StackticianApi.new(options[:conf])
json = @client.make_get_request("stacks",{})
p json