class MyWS
  @log = Logger.new(STDOUT)
  @@clients = []
  @@users = []

  EM::WebSocket.run(:host => '0.0.0.0', :port => '3001') do |ws|

    ws.onopen do |handshake|

      @@clients << ws
      @user = User.find_by("id", handshake.query["key"]).id
      @@users << @user unless @@users.include?(@user)
      a = -1
      @@users.each do |u|
        a += 1
      end
      ws.send("Connected to #{handshake.path} as user N°#{@user}")
      @log.info("Connected to '#{handshake.path}' as user N°#{@user}")
    end

    ws.onclose do
      i = -1
      @@clients.each do |c|
        i += 1
        break if c == ws
      end
      @@users.delete_at(i)
      @log.info("WebSocket connection closed.")
      @@clients.delete(ws)
    end

    ws.onmessage do |msg|
      puts "Received message: #{msg}"
      # ajouter au message les informations nécessaires (user_id && conversation_id)
      # Message.new(msg, 2 ,1)
      # if Message.new, send msg to the view below
      @@clients.each do |socket|
        socket.send(msg)
      end
    end
  end

  def self.users
    @@users
  end
end
