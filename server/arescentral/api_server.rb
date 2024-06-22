module AresCentral
  
  class ApiLoader
    
    # Start the reactor
    def run(opts = {})

      # define some defaults for our app
      server  = opts[:server] || 'thin'
      host    = opts[:host]   || '0.0.0.0'
      port    = opts[:port]   || '8181'
      web_app = ApiServer
      
      dispatch = Rack::Builder.app do
        map '/' do
          run web_app
        end
      end
      
      AresCentral.logger.info "Server starting on #{port}"

      Rack::Server.start({
        app:    dispatch,
        server: server,
        Host:   host,
        Port:   port,
        signals: false        
      })
    end
  end

  class ApiServer < Sinatra::Base

    # threaded - False: Will take requests on the reactor thread
    #            True:  Will queue request for background thread
    configure do
      #session_secret = File.read('session_secret.txt')
      #use Rack::Session::Cookie, secret: session_secret # Use this instead of set :sessions => true to avoid post clearing session info.

      set :threaded, false #false
      enable :cross_origin
      #enable :sessions
    end    
    
    attr_accessor :ip_addr, :user
    
    
    before do
      response.headers['Access-Control-Allow-Origin'] = '*'
      content_type 'text/json'

      @ip_addr = request.ip

      database = AresCentral::Database.new
      database.connect
      
      begin
        @user = Authorization.check_auth(request_auth)
        if (@user)
          @user.update(last_ip: @ip_addr)
        end
      rescue AuthenticationError
        status 401
      end

    end
  
    # routes...
    options "*" do
       
      response.headers["Allow"] = "GET, POST, OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
      response.headers['Access-Control-Allow-Origin'] = '*'
           
      200
    end
    
    def request_auth
      header = request.env['HTTP_AUTHORIZATION'] || ""
      return nil if header.blank?
      
      parts = header.gsub("Bearer ", "").split(':')
      return nil if parts.count != 2
      
      Authorization.new(parts[0], parts[1])
    end
        
    def get_request_body_json
      raise "Invalid request." if !request
      raise "No request body present." if !request.body
      JSON.parse(request.body.read)
    end
    
    def handle_request(&block)
      AresCentral.logger.debug "Request to #{request.fullpath} #{request.get? ? 'GET' : 'POST' } from #{@user ? @user.name : 'Anonymous'}"
      
      begin
        data = yield block
        data.to_json
      rescue InsufficientPermissionError
        AresCentral.logger.debug "Insufficient permissions!"
        status 403
      rescue NotFoundError
        AresCentral.logger.debug "Request not found!"
        status 404
      rescue Exception => ex
        AresCentral.logger.error "Exception in #{request.url}: #{ex.message} #{ex.backtrace[0,10]}"
        error "Request failed."
      end
    end  
    
    def handle_api(&block)
      AresCentral.logger.debug "API request to #{request.fullpath} #{request.get? ? 'GET' : 'POST' }"
      
      begin
        data = yield block
        data
      rescue Exception => ex
        AresCentral.logger.error "Exception in #{request.url}: #{ex.message} #{ex.backtrace[0,10]}"
        error "Request failed."
      end
    end    
  end
end