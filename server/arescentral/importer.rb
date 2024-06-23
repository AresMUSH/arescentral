module AresCentral
  class Importer
    def self.import_handle(body)
      puts "CREATE HANDLE: #{body}"
       
      begin
              
          handle = Handle.create(
            name: body['name'],
            autospace: body['autospace'],
            page_autospace: body['page_autospace'],
            page_color: body['page_color'],
            quote_color: body['quote_color'],
            timezone: body['timezone'],
            password_hash: body['password_hash'],
            profile: body['profile'],
            image_url: body['image_url'],
            email: body['email'],
            security_question: body['security_question'],
            screen_reader: body['screen_reader'],
            link_codes: body['link_codes'],
            forum_banned: body['forum_banned'],
            past_links: body['past_links'],
            is_admin: body['is_admin'],
            ascii_only: body['ascii_only'],
            last_ip: body['last_ip'],
            old_id: body['old_id']
          )
          
          handle.update(created_at: body['created_at'])
          
          puts "Handle created"
          puts handle.inspect
          
      rescue Exception => e
        puts "****** ERROR ********* #{e} backtrace=#{e.backtrace[0,30]}"
      end
        
    end
    
    def self.import_game(body)
      puts "CREATE GAME: #{body}"
       
      begin
              
          game = Game.create(
          name: body['name'],
          description: body['description'],
          host: body['host'],
          port: "#{body['port']}".to_i,
          category: body['category'],
          website: body['website'],
          api_key: body['api_key'],
          public_game: body['public_game'],
          last_ping: body['last_ping'],
          activity: body['activity'],
          status: body['status'],
          wiki_archive: body['wiki_archive'],            
          old_id: body['old_id']
          )
          
          game.update(created_at: body['created_at'])
          
          puts "Game created"
          puts game.inspect
          
      rescue Exception => e
        puts "****** ERROR ********* #{e} backtrace=#{e.backtrace[0,30]}"
      end
        
      
    end
    
    
    def self.import_friendship(body)
      puts "CREATE FRIENDSHIP: #{body}"
       
      begin
              
          friendship = Friendship.create(
            owner: Handle.find_by_name(body['owner']),
            friend: Handle.find_by_name(body['friend'])
          )
          
          puts "Frienship created"
          puts friendship.inspect
          
      rescue Exception => e
        puts "****** ERROR ********* #{e} backtrace=#{e.backtrace[0,30]}"
      end
        
      
    end
    
    def self.import_past_char(body)
      puts "CREATE PAST CHAR: #{body}"
       
      begin
        
        game = Game.all.select { |g| g.old_id == body['game'] }.first
        handle = Handle.find_by_name(body['handle'])
        # Past chars have no char ID
        link = game.create_or_update_linked_char(body['name'], nil, handle)
        link.update(retired: true)
              
          puts "Past Char created"
          puts char.inspect
          
      rescue Exception => e
        puts "****** ERROR ********* #{e} backtrace=#{e.backtrace[0,30]}"
      end
        
      
    end
    
    def self.import_linked_char(body)
      puts "CREATE LINKED CHAR: #{body}"
       
      begin
        
        game = Game.all.select { |g| g.old_id == body['game'] }.first
        handle = Handle.find_by_name(body['handle'])
        link = game.create_or_update_linked_char(body['name'], body["char_id"], handle)
        
          puts "Linked Char created"
          puts char.inspect
          
      rescue Exception => e
        puts "****** ERROR ********* #{e} backtrace=#{e.backtrace[0,30]}"
      end
        
      
    end
    
    
    def self.import_plugin(body)
      puts "CREATE PLUGIN: #{body}"
       
      begin
              
          plugin = Plugin.create(
            handle: Handle.find_by_name(body['handle']),
            name: body['name'],
            keyname: body['key'],
            description: body['description'],
            url: body['url'],
            custom_code: body['custom_code'],
            web_portal: body['web_portal'],
            category: body['category'],
            installs: body['installs']
          )
          
          puts "Plugin created"
          puts plugin.inspect
          
      rescue Exception => e
        puts "****** ERROR ********* #{e} backtrace=#{e.backtrace[0,30]}"
      end
              
    end    
  end
end


