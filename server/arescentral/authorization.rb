module AresCentral
  class Authorization
    attr_accessor :id
    attr_accessor :auth_token
    
    def initialize(id, auth_token)
      self.id = id
      self.auth_token = auth_token
    end
    
    # Returns handle if valid auth auth_token, or nil if not
    def self.check_auth(auth)
      return nil if !auth
      handle = Handle.find_by_name_or_id(auth.id)
      return nil if !handle
      if handle.is_valid_auth_token?(auth.auth_token)
        return handle 
      else        
        AresCentral.logger.debug "Auth invalid for #{auth.id}."
        raise AuthenticationError.new
        return nil
      end
    end
    
    def self.build_login_session(handle)
      expiry_timestamp = (handle.auth_token_expiry || "0").to_i
      { name: handle.name, id: handle.id, token: handle.auth_token, is_admin: handle.is_admin, expires: expiry_timestamp }
    end
  end
end