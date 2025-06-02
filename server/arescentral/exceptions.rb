module AresCentral
  class InsufficientPermissionError < StandardError
  end
  
  class NotFoundError < StandardError
  end  
  
  class AuthenticationError < StandardError
  end
end