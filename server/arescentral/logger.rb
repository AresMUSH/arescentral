module AresCentral
  def self.logger
    @logger
  end
  
  def self.start_logger
    @logger = AresLogger.new
  end
    
  class AresLogger
    attr_accessor :logger
    
    def initialize
      unless File.directory?("logs")
        FileUtils.mkdir_p("logs")
      end
      
      @file_logger = Logger.new('logs/log.txt', 10, 125000)
      @file_logger.formatter = proc { |severity, time, progname, msg| format_log_entry(severity, time, msg) }

      @stdout_logger = Logger.new($stdout)
      @stdout_logger.formatter = proc { |severity, time, progname, msg| format_log_entry(severity, time, msg) }
    end    
    
    def format_log_entry(severity, time, msg)
      
      # Could use msg.dump here to escape certain chars.
      "#{time} #{severity} - #{msg}\n"
    end
    
    def fatal(msg)
      @file_logger.fatal msg
      @stdout_logger.fatal msg
    end
    
    def error(msg)
      @file_logger.error msg
      @stdout_logger.error msg
    end
    
    def warn(msg)
      @file_logger.warn msg
      @stdout_logger.warn msg
    end
        
    def info(msg)
      @file_logger.info msg
      @stdout_logger.info msg
    end
        
    def debug(msg)
      @file_logger.debug msg
      @stdout_logger.debug msg
    end
    
    
  end
end
