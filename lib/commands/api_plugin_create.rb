class ApiPluginCreateCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    author_name = @params[:author]
    name = @params[:name]
    key = (@params[:key] || "").downcase
    description = @params[:description]
    url = @params[:url]

    # custom_code: None / Minor / etc.
    custom_code = @params[:custom_code] || "None"

    # web_portal: None / Partial / Full
    web_portal = @params[:web_portal] || "None"
        
    # category: RP / Skills / Building / Community / System
    category = @params[:category] || "Other"
    
    if (!name || !key || !description || !url)
      return {  status: "failure", error: "Missing required params." }.to_json
    end
    
    if (@params[:api_key] != @server.keys['master_api_key'])
      return { status: "failure", error: "Not authorized." }.to_json
    end
    
    author = HandleFinder.find_by_name(author_name, self)
    if (!author)
      return { status: "failure", error: "Author not found." }.to_json
    end
    
    plugin = Plugin.all.select { |p| p.key == key }.first
    if (plugin)
      return { status: "failure", error: "Plugin #{name} already exists." }.to_json
    end
        
    Plugin.create(
      name: name,
      key: key,
      description: description,
      url: url,
      custom_code: custom_code,
      web_portal: web_portal,
      category: category,
      installs: 0,
      handle: author
    )  
    
    { status: "success", data: {} }.to_json
  end
end