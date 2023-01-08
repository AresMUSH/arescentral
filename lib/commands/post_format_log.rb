class PostFormatLogCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    
    format = (@params[:format] || '').downcase.strip

    file = @params[:file][:tempfile]
    log = file.read
    
    puts log
    
    error = nil
    parsed_log = ""
    
    begin
      parser = LogParser.new(format)
      
      begin
        lines = []        
        
        log.force_encoding('ASCII-8BIT').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?').split("\n").each do |l|
          lines << l
        end        
        parsed_log = parser.parse(lines)
      rescue Exception => e
        error = "Error reading file.  Please make sure it's a plain text log.  If it is, lease send this error to faraday@aresmush.com: \r\n\r\n#{e} #{e.backtrace}"
      end
    rescue Exception => e
      error = "Sorry!  Something went wrong.  Please send this error to faraday@aresmush.com: #{e}"
    end
    
    @view_data[:error] = error
    @view_data[:log] = parsed_log
    
    @server.content_type 'text/plain'
    #@server.render_erb :"logs/format"
    parsed_log
  end
end


