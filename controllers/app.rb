
class WebApp < Sinatra::Base
  register Sinatra::Flash
  register Sinatra::CrossOrigin
  
  configure do    
    set :port, 9292
    set :threaded, false
    set :auth_keys, {}
    enable :cross_origin
    set :sessions => true
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

  attr_accessor :view_data, :user, :sso
  
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
    @user = user_id ? Handle.find(user_id) : nil
    @view_data = {}
  end

  get '/' do
     erb :index, :layout => :default
  end
  
end