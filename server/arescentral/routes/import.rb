module AresCentral
  class ApiServer
    post '/api/v2/import/handle' do
      body = self.get_request_body_json
      # Importer.import_handle(body)
      {}.to_json
      
    end
    
    post '/api/v2/import/game' do
      body = self.get_request_body_json
      # Importer.import_game(body)
      {}.to_json
    end
    
    
    post '/api/v2/import/handle/friendship' do
      body = self.get_request_body_json
      # Importer.import_handle(body)
      {}.to_json
      
    end
    
    post '/api/v2/import/handle/pastchar' do
      body = self.get_request_body_json
      # Importer.import_past_char(body)
      {}.to_json
    end
    
    post '/api/v2/import/handle/linkedchar' do
      body = self.get_request_body_json
      # Importer.import_linked_char(body)
      {}.to_json
      
    end
    
    
    post '/api/v2/import/handle/pastchar' do
      body = self.get_request_body_json
      # Importer.import_plugin(body)
      {}.to_json      
    end    
  end
end