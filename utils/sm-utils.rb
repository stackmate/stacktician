require 'openssl'
require 'base64'
require 'cgi'
require 'openssl'
require 'uri'
require 'digest/sha1'
require 'net/https'
require 'net/http'
require 'json'
require 'yaml'

class StackticianApi

  def initialize(conf='config.yml')
    begin
      @conf = YAML.load_file('config.yml')
    rescue
      raise "Bad YAML config file"
    end
    @api_key = @conf['api_key']
    @secret_key = @conf['secret_key']
    @base_url = @conf['url']
  end

  def make_get_request(api_url,params)
    params['apiKey'] = @api_key
    data = params.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')

    signature = OpenSSL::HMAC.digest 'sha1', @secret_key, data.downcase
    signature = Base64.encode64(signature).chomp
    signature = CGI.escape(signature)
    data.delete('id')

    url = @base_url+"/"+"#{api_url}?#{data}&signature=#{signature}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = @use_ssl
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    json = JSON.parse(response.body)
    json
  end

  def make_post_request(api_url,params,file=nil)
    params['apiKey'] = @api_key
    url = @base_url+"/"+"#{api_url}"
    cmd = "curl -X POST "
    params.each do |k,v|
      cmd = cmd + "--data '#{k}=#{v}' "
    end
    p params
    if !file.nil?
      cmd = cmd + " --data-urlencode body@"+file+" "
    end
    cmd = cmd + url
    json = `#{cmd}`
    json = JSON.parse(json)
    json
  end
end