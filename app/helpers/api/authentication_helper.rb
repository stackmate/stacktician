require 'base64'
require 'cgi'
require 'openssl'
require 'uri'
require 'digest/sha1'
module API
  module AuthenticationHelper
    def authenticate_request
      begin
        api_key = params[:apiKey]
        @api_user = User.find_by_api_key!(api_key)
        @api_user = User.find(2)
        return
        #raises 404 by default for ActiveRecord::RecordNotFound with exclamation
        sec_key = @api_user.sec_key
        signature = params[:signature]
        path_params = request.path_parameters
        params_clone = params.except(*path_params.keys)
        params_clone.delete(:signature)
        data = params_clone.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
        #p request
        computed_signature = OpenSSL::HMAC.digest 'sha1', sec_key, data.downcase
        computed_signature = Base64.encode64(computed_signature).chomp
        if !computed_signature.eql?(signature)
          ::Rails.logger.debug("API signature mismatch. Expected #{computed_signature} received #{signature}")
          redirect_to :status => 404
        end
        ::Rails.logger.debug("Successfuly authenticated request for #{data}")
      rescue => e
        redirect_to :status => 404
      end
    end
  end
end