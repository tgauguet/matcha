class MyWS
  @log = Logger.new(STDOUT)
  @@users = {}

  def self.users
    @@users
  end

  def self.online?(user_id)
    @@users[user_id.to_s]
  end

  EM::WebSocket.run(:host => '0.0.0.0', :port => '3001') do |ws|

    ws.onopen do |handshake|
      user = User.find_by('websocket_token', handshake.query['token']) if !handshake.query['token'].nil?
      if user && (user.id.to_s != handshake.query['key'])
        @@users[handshake.query['key']] = ws
        @log.info("Connected to '#{handshake.path}' as user N°#{@user}")
      end
    end

    ws.onclose do
      @log.info("WebSocket connection closed.")
      res= @@users.select{|key, hash| hash == ws}.each {|k, v|
          @@users[k] = nil
      }
    end

    ws.onmessage do |msg|
      puts "Received message: #{msg}"
    end
  end

end
