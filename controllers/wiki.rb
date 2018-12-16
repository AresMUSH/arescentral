class WebApp  
  
  get "/wiki" do
    public_games = Game.where(public_game: true)
    @closed_games = public_games
#    @closed_games = public_games.select { |g| !g.is_open? }
    render_erb :wiki, :layout => :default
  end
  
  get "/wiki/*" do
    path = File.join("wiki", params["splat"])
    if (File.directory?(path))
      redirect to ("#{path}/index.html")
    elsif (File.exist?(path))
      send_file path
    else
      redirect to("not_found")
    end
  end
  
  not_found do
     render_erb :not_found, :layout => :default
   end
end