module AresCentral
  class ApiHandleFriendsCmd
    def initialize(params)
      @handle_id = params["handle_id"]
    end
  
    def handle
      handle = Handle.find_by_old_or_new_id(@handle_id)
      if (!handle)
        return { status: "failure", error: "Handle not found." }.to_json
      end
    
      data = {
        friends: handle.friends.map { |f| f.name }
      }
    
      { status: "success", data: data }.to_json
    end
  end
end

