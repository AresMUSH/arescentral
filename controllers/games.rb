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
    
    def format_game_status(*args)
      status = args[0]
      case status
      when "In Development", "Beta"
        label_class = "info"
      when "Open"
        label_class = "success"
      when "Sandbox"
        label_class = "warning"
      when "Closed"
        label_class = "danger"
      end
      "<span class='label label-#{label_class}'>#{status}</span>"
    end
  end
  
  
   get "/games" do
    @open_games = Game.where(is_open: true)
    @closed_games = Game.where(is_open: false)
    
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