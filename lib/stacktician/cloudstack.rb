#require 'cloudstack_ruby_client'

module Stacktician
  module CloudStack
    def self.get_client()
      initialized = true
      url = ENV['CS_URL']  or initialized = false
      apikey = ENV['CS_ADMIN_APIKEY']  or initialized = false
      seckey = ENV['CS_ADMIN_SECKEY'] or initialized = false
      if !initialized or ENV['DEMO_MODE'] == 'NOOP'
          return nil
      end
#      client = CloudstackRubyClient::Client.new(url, apikey, seckey, false)
      client = StackMate::CloudStackClient.new(url, apikey, seckey, false)
      client
    end

    def self.create_user(name, email, password)
      client = self.get_client()
      if !client
          return nil
      end
      args = {}
      args['accounttype'] = '0'
      args['firstname'] = name
      args['lastname'] = 'Shmoe'
      args['domain'] ='ROOT' 
      args['username'] = name 
      args['email'] = email  
      args['password'] = password 
#      resp = client.send('createAccount', args)
      resp = client.api_call('createAccount', args)
      userid = resp['account']['user'][0]['id']
      userid
    end

    def CloudStack.create_user_keys(userid)
      client = self.get_client()
      if !client
          return nil
      end
      keypair = {}
#      resp = client.send('registerUserKeys', {'id' => userid})
      resp = client.api_call('listUsers', {'username' => name})
      if resp.nil? or resp.empty?
          return nil
      end
      keypair[:api_key] = resp['userkeys']['apikey']
      keypair[:sec_key] = resp['userkeys']['secretkey']
      keypair
    end

    def CloudStack.get_user_keys(name)
      client = self.get_client()
      if !client
          return nil
      end
      resp = client.send('listUsers', {'username' => name})
      if resp.nil? or resp.empty?
          return nil
      end
      keypair = {}
      keypair[:api_key] = resp['user'][0]['apikey']
      keypair[:sec_key] = resp['user'][0]['secretkey']
      if keypair[:api_key].nil? or keypair[:sec_key].nil?
          userid = resp['user'][0]['id']
          keypair = self.create_user_keys(userid)
      end
      keypair
    end

    def CloudStack.create_and_get_keys(username, email, password)
        keypair = self.get_user_keys(username)
        if keypair.nil?
            userid = self.create_user(username, email, password)
            keypair = self.create_user_keys(userid)
        end
        keypair
    end
    def CloudStack.validate_user_keys(apikey, secretkey)
      client = self.get_client
      if ENV['DEMO_MODE'] == 'NOOP'
        return true
      end
      if !client
        return false
      end
      resp = client.api_call('getUser',{'userapikey' => apikey})
      if resp.nil? or resp.empty?
        return false
      end
      secretkey_in_cs = resp['user']['secretkey']
      return secretkey.to_s.eql?(secretkey_in_cs)
    end
  end
end
