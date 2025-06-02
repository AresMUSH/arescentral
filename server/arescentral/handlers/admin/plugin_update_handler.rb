module AresCentral
  class PluginUpdateHandler
    def initialize(user, params, body_data)
      @user = user
      @plugin_id = params["plugin_id"]
      @fields = body_data
    end
  
    def self.required_fields
      [ "name", "description", "url" ]
    end
    
    def handle
      authorized = @user && @user.is_admin?
      if (!authorized)
        raise InsufficientPermissionError.new
      end

      PluginUpdateHandler.required_fields.each do |field|
        if (@fields[field].blank?)
          return { error: "Missing required field #{field}." }
        end
      end
    
      plugin = Plugin[@plugin_id]
      if (!plugin)
        return { error: "Plugin not found." }
      end
      
      author_name = @fields["author_name"]
      name = @fields["name"]
      description = @fields["description"]
      url = @fields["url"] || ""

      # custom_code: should be a bool but was descriptive at one time
      custom_code = "#{@fields['custom_code']}".to_bool ? "Yes" : "None"

      # custom_code: should be a bool but was descriptive at one time
      web_portal = "#{@fields['web_portal']}".to_bool ? "Yes" : "None"
        
      # category: RP / Skills / Building / Community / System
      category = @fields["category"] || "Other"
    
      key = Plugin.url_to_key(url)
      if (key.blank?)
        return { error: "GitHub URL not compatible with installer." }
      end
          
      author = Handle.find_by_name(author_name)
      if (!author)
        return { error: "Author not found." }
      end
    
      other_plugin = Plugin.all.select { |p| p != plugin && p.keyname == key }.first
      if (other_plugin)
        return { error: "Plugin #{key} already exists." }
      end
        
      plugin.update(
        name: name,
        keyname: key,
        description: description,
        url: url,
        custom_code: custom_code,
        web_portal: web_portal,
        category: category,
        installs: 0,
        handle: author
      )  
    
      {
        id: plugin.id
      }
    end
  end
end