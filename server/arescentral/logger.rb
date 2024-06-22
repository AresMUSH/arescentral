include Log4r

module AresCentral
  def self.logger
    @logger
  end
  
  def self.logger=(logger)
    @logger = logger
  end
    
  class Logger
    attr_accessor :logger
    
    def start
      unless File.directory?("logs")
        FileUtils.mkdir_p("logs")
      end
      config = YAML.load_file("logger.yml")
      configurator = Log4r::YamlConfigurator
      configurator.decode_yaml config
      AresCentral.logger = Log4r::Logger['ares']
    end    
  end
end
