class MyWS
  @log = Logger.new(STDOUT)
  @@clients = []
  @@users = []

  EM::WebSocket.run(:host => '0.0.0.0', :port => '3001') do |ws|

    ws.onopen do |handshake|
      @@clients << ws
      @user = User.find_by("id", handshake.query["key"]).id
      @@users << @user unless @@users.include?(@user)
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

    ws.onmessage do |msg, tes|
      i = -1
      @@clients.each do |c|
        i += 1
        break if c == ws
      end
      val = JSON.parse(msg)
      if val['message'] && val['conversation']
        Message.new(val['message'], @@users[i], val['conversation'])
      end
      @@clients.each do |socket|
        socket.send(msg)
      end
    end
  end

  def self.users
    @@users
  end
end
