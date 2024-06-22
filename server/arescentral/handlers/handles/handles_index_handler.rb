module AresCentral
  class HandlesIndexHandler
        
    def initialize(user, params)
    end
    
    def handle
      Handle.all.to_a.sort_by { |h| h.name_upcase }.select.map { |g| g.summary_data }
    end
  end
end
