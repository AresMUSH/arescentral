class WebApp  
  
  get "/wiki" do
    redirect "/games/archive"
  end
  
  # get "/wiki/*" do
  #  path = File.join("wiki", params["splat"])
  #  if (File.directory?(path))
  #    redirect to ("#{path}/index.html")
  #  elsif (File.exist?(path))
  #    send_file path
  #  else
  #    redirect to("not_found")
  #  end
  # end
  get "/log" do
   erb :"logs/index", :layout => :default
  end

  post "/log/format" do
    handler = PostFormatLogCmd.new(params, session, self, @view_data)
    handler.handle     
  end
  
  get "/terms" do
    erb :'/terms', :layout => :default
  end
  
  not_found do
     render_erb :not_found, :layout => :default
   end
end