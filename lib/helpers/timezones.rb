module TimezoneHelper
  def self.timezones
    Timezone.names.sort { |a, b| sort_time(a, b) }
  end
  
  def self.sort_time(a, b)
    a_is_us = a.include?("US")
    b_is_us = b.include?("US")
   
    if (a_is_us && b_is_us)
      return a <=> b
    elsif (a_is_us)
      return -1
    elsif (b_is_us)
      return 1
    else
      return a <=> b
    end
  end
end