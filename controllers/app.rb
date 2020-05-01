class WebApp < Sinatra::Base
  register Sinatra::Flash
  register Sinatra::CrossOrigin
  
  configure do
    session_secret = File.read('session_secret.txt')
    use Rack::Session::Cookie, secret: session_secret # Use this instead of set :sessions => true to avoid post clearing session info.
    set :port, 9292
    set :threaded, false
    set :auth_keys, {}
    enable :cross_origin
    set :views, "#{settings.root}/../views"    
    set :static, true
    enable :logging
    set :public_folder, 'public'
    
    file = File.new("#{settings.root}/sinatra.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end
      
  register do
    def auth (type)
      condition do
        unless send("is_#{type}?")
          flash[:error] = "Please log in first."
          redirect "/login" 
        end
      end
    end
  end

  attr_accessor :view_data, :user, :sso, :ip_addr
  
  helpers do
    def is_user?
      @user != nil
    end
    
    def show_flash(type, message)
      flash[:type] = message
    end
    
    def redirect_to(url)
      redirect to(url)
    end
    
    def render_erb(template, args = {})
      erb template, args
    end
  end

  def initialize
    Database.load   
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    super
  end
  
  before do
    user_id = session[:user_id]
    @ip_addr = request.ip
    @user = user_id ? Handle.find(user_id) : nil
    if (@user)
      @user.last_ip = @ip_addr
      @user.save!
    end
    @view_data = {}
  end

  get '/' do
    erb :index, :layout => :default
  end
  
end