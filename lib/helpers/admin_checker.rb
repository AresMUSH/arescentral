class AdminChecker
  def self.check(server)
    if (server.user && server.user.is_admin)
      return true
    end
    
    server.show_flash :error, "You do not have admin permission."
    server.redirect_to '/games'
    false
  end
end
