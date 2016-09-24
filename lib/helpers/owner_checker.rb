class OwnerChecker
  def self.check(server, handle)
    if (server.user == handle)
      return true
    end
    
    server.show_flash :error, "You can't edit someone else's handle."
    server.redirect_to '/handles'
    false
  end
end
