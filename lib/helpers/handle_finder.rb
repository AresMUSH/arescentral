class HandleFinder
  def self.find(handle_id, server)
    handle = Handle.find(handle_id)
  
    if (!handle)
      server.show_flash :error, "Handle not found."
      server.redirect_to '/handles'
    end
    handle
  end
  
  def self.find_by_name(handle_name, server)
    handle = Handle.find_by_name(handle_name).first
  
    if (!handle)
      server.show_flash :error, "Handle not found."
      server.redirect_to '/handles'
    end
    handle
  end
end
