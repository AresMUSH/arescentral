class WebApp
   get "/plugins" do
     @plugins = Plugin.all.sort_by { |p| p.name }
     erb :"plugins/index", :layout => :default
   end
   
   get "/themes" do
     erb :"themes/index", :layout => :default
   end
end