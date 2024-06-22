module AresCentral
  class HandleDetailHandler
        
    def initialize(user, params)
      @user = user
      @handle_id = params[:handle_id]      
    end
    
    def handle
      handle = Handle.find_by_name_or_id(@handle_id)
      if (!handle)
        raise NotFoundError.new
      end
      handle.detail_data(@user)
    end
  end
end
