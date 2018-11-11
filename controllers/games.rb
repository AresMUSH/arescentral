class WebApp
  helpers do
    def format_up_status(*args)
      status = args[0]
      case status
      when "Up"
        label_class = "success"
      when "Down"
        label_class = "danger"
      else
        label_class = "warning"
      end
      "<span class='label label-#{label_class}'>#{status}</span>"
    end
    
    def format_privacy(*args)
      status = args[0]
      case status
      when false
        label_class = "default"
        label_text = "Private"
      when true
        label_class = "primary"
        label_text = "Public"
      else
        label_class = "warning"
        label_text = "Unknown"
      end
      "<span class='label label-#{label_class}'>#{label_text}</span>"
    end
    
    def format_game_status(*args)
      status = args[0]
      case status
      when "In Development", "Beta", "Alpha"
        label_class = "info"
      when "Open"
        label_class = "success"
      when "Sandbox"
        label_class = "warning"
      when "Closed"
        label_class = "danger"
      else
        status = "Unknown"
        label_class = "info"
      end
      "<span class='label label-#{label_class}'>#{status}</span>"
    end
  end
  
  
   get "/games" do
    public_games = Game.where(public_game: true)
    @open_games = public_games.select { |g| g.is_open? }
    @closed_games = public_games.select { |g| !g.is_open? }
    
    erb :"games/index", :layout => :default
   end
   
   post "/game/:game_id/delete" do
     handler = PostDeleteGameCmd.new(params, session, self, @view_data)
     handler.handle
   end
   
   get "/game/:game_id/detail" do
     handler = GetGameDetailCmd.new(params, session, self, @view_data)
     handler.handle     
   end
   
   get "/games/admin" do
     if (!user || !user.is_admin)
       show_flash :error, "You are not allowed to do that."
       redirect_to '/games'
     end
     
    @games = Game.all.sort_by { |g| [g.address, g.name, g.last_ping] }  
    erb :"games/admin", :layout => :default
   end
  
end