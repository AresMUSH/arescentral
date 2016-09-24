class WebApp
  helpers do
    def format_status(*args)
      status = args[0]
      case status
      when "Up"
        "<span class='game-up'>#{status}</span>"
      when "Closed"
        "<span class='game-closed'>#{status}</span>"
      else
        "<span class='game-unknown'>#{status}</span>"
      end
    end
  end
  
  get "/games" do
    @open_games = Game.where(is_open: true)
    @closed_games = Game.where(is_open: false)
    
    erb :"games/index", :layout => :default
   end
   
   get "/game/:game_id/detail" do
     handler = GetGameDetailCmd.new(params, session, self, @view_data)
     handler.handle     
   end
  
end