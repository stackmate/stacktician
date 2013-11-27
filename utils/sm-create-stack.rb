require_relative 'sm-utils'
require 'optparse'
require 'json'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: sm-create-stack.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"
  opts.on(:REQUIRED, "--template_id ID", String, "ID of template to create stack from") do |id|
    options[:template_id] = id
  end
  opts.on(:REQUIRED, "--stack_name NAME", String, "Name of stack to create") do |id|
    options[:stack_name] = id
  end
  options[:conf] = 'config.yml'
  opts.on("--config CONF",String, "Path to YAML config file. defaults to config.yml") do |conf|
    options[:conf] = conf
  end
  options[:params] = {}
  params = {}
  opts.on("--parameters [KEY1=VALUE1 KEY2=VALUE2..]", "Parameter values used to create the stack.") do |p|
    p.split(';').each do |k|
      i = k.split('=')
      params[i[0]] = i[1]
    end
  end
  options[:params] = params
  opts.on("-h", "--help", "Show this message")  do
    puts opts
    exit
  end
end

begin
  opt_parser.parse!(ARGV)
  raise "Missing Template ID" if options[:template_id].nil?
  raise "Missing Stack Name" if options[:stack_name].nil?
rescue => e
  puts e.message.capitalize
  puts opt_parser.help()
  exit 1
end

@client = StackticianApi.new(options[:conf])
url = "stacks/new"
json = @client.make_get_request(url,options[:params].merge({'template_id'=>options[:template_id]}).merge({'stack_name' => options[:stack_name]}))
p json