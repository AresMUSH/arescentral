class Database
  def self.load
    begin
      file = File.open( 'db.yml' )
      db_config = YAML::load( file )
      Mongoid.load_configuration(db_config)
  
      Mongoid.logger.level = Logger::WARN
      Mongo::Logger.logger.level = Logger::WARN            
      
    rescue Exception => e
      puts "Error loading database config.  Please check your dabase configuration and installation requirements: #{e}."
      raise e
    end   
  end
end