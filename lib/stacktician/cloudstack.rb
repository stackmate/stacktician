module Stacktician
  module CloudStack
    def CloudStack.create_and_get_keys(name, email, password)
      initialized = true
      url = ENV['CS_URL']  or initialized = false
      apikey = ENV['CS_ADMIN_APIKEY']  or initialized = false
      seckey = ENV['CS_ADMIN_SECKEY'] or initialized = false
      if !initialized or ENV['DEMO_MODE'] == 'NOOP'
          return nil
      end
      client = CloudstackRubyClient::Client.new(url, apikey, seckey, false)
      args = {}
      args['accounttype'] = '0'
      args['firstname'] = name
      args['lastname'] = 'Shmoe'
      args['domain'] ='ROOT' 
      args['username'] = name 
      args['email'] = email  
      args['password'] = password 
      resp = client.send('createAccount', args)
      userid = resp['account']['user'][0]['id']
      keypair = {}
      resp = client.send('registerUserKeys', {'id' => userid})
      keypair[:api_key] = resp['userkeys']['apikey']
      keypair[:sec_key] = resp['userkeys']['secretkey']
      keypair
    end
  end
end
