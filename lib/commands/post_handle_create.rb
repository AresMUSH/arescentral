class HttpConnector
  def get(url)
    uri = URI.parse(url)
    opts = { open_timeout: 1, read_timeout: 1, use_ssl: uri.scheme == "https" }
    Net::HTTP.start(uri.hostname, uri.port, opts ) do |http|
      resp = http.request_get(uri.request_uri)
      return resp
    end
  end
end

class PostHandleCreateCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    if (!RecaptchaHelper.verify(@params["g-recaptcha-response"]))
      @server.show_flash :error, "Please prove you're human first."
      @server.redirect_to '/handle/create'
      return
    end
    
    puts "Getting blacklist"

    begin
      blacklist = HttpConnector.get('http://rhostmush.com/blacklist.txt')
      if (blacklist)
        blacklist = blacklist.split("\n").select { |b| b != "ip" && !b.empty? }
        File.open('blacklist.txt', 'w') do |f|
          f.puts blacklist.join("\n")
        end
      end
    rescue Exception => ex
      puts "Error reading blacklist from rhost.com."
    end
    
    puts "Checking for banned sites"
    
    blacklist = File.read('blacklist.txt').split("\n").select { |b| b != "ip" && !b.empty? }
    banned = File.read('banned.txt').split("\n").select { |b| b != "ip" && !b.empty? }
    ban_list = banned.concat(blacklist)

    if (ban_list.include?(@server.ip_addr))
      @server.show_flash :error, "You cannot create a handle at this time.  Your site has been banned, or you're connected from a proxy/VPN server that's on our blacklist."
      @server.redirect_to '/'
      return
    end
            
    handle = Handle.new
    handle.create_from(@params)
   
    if (!handle.valid?)      
      @server.show_flash :error, handle.error_str
      @server.redirect_to '/handle/create'
      return
    end

    @server.show_flash :notice, "Handle created!  You can now log in and go to 'My Account' to set your preferences."
    handle.change_password(@params[:password])
    handle.save!
    @server.redirect_to '/login'
  end
end
