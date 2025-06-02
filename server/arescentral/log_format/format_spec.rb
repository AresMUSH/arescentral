class FormatSpec
  attr_reader :type, :match, :replace, :spec
  def initialize(line)
    @spec = line
    matches = /^([^|]+)\|([^|]+)\|([^|]*)$/.match(line)
    if (matches.nil?)
      @type = "Omit"
      @match = line
      @replace = nil
    else
      @type = matches.captures[0]
      @match = matches.captures[1]
      @replace = matches.captures[2]
    end      
  end
  
  def matches?(line)
    r = Regexp.new(@match)
    r.match(line)
  end
  
  def parse(line)
    if (@type == "Replace")
      return @replace.gsub("$&", line)
    elsif (@type == "Keep")
      return line
    end
    
    # Default to Omit for all other types
    return ""
  end
  
  def to_s
    @spec
  end
end