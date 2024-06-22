module AresCentral 
  # @engineinternal true
  class Database

    def self.build_url(host_and_port, password)
      "redis://:#{password}@#{host_and_port}"
    end

    def connect
      config = YAML.load_file("db.yml")
      raw_url = config["db"]["url"]
      password = config["db"]["password"]
      
      
      redis_url_and_pw = Database.build_url(raw_url, password)
      AresCentral.logger.info("Connecting to database: #{raw_url}")
      
      begin
        Ohm.redis = Redic.new(redis_url_and_pw)
                    
      rescue Exception => e
        AresCentral.logger.fatal("Error loading database config.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end    
  end
end