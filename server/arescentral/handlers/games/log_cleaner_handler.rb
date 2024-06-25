module AresCentral
  class LogCleanerHandler
        
    def initialize(body_data)
      @log = body_data['log']
      @format = body_data['format']
    end
    
    def handle
      
      
      begin
        parser = LogParser.new(@format)
        lines = []        
        
        @log.force_encoding('ASCII-8BIT').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?').split("\n").each do |l|
          lines << l
        end        
        parsed_log = parser.parse(lines)
      rescue Exception => e
        AresCentral.logger.debug e
        return { error: "Error reading file.  Please make sure it's a plain text log.  If it is, please contact staff." }
      end

      { log: parsed_log }
    end
      
  end
end
