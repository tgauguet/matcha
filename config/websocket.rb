class MyWS
  @log = Logger.new(STDOUT)
  @@clients = []
  @@users = {}

  def self.users
    @@users
  end

  def self.online?(user_id)
    @@users[user_id.to_s]
  end

  EM::WebSocket.run(:host => '0.0.0.0', :port => '3001') do |ws|

    ws.onopen do |handshake|
      # @@clients << ws
      # @user = User.find_by("id", handshake.query["key"]).id
      @@users[handshake.query['key']] = ws
      # @@users << @user unless @@users.include?(@user)
      # ws.send("Connected to #{handshake.path} as user N°#{@user}")
      @log.info("Connected to '#{handshake.path}' as user N°#{@user}")
    end

    ws.onclose do
      @log.info("WebSocket connection closed.")
      res= @@users.select{|key, hash| hash == ws}.each {|k, v|
          @@users[k] = nil
      }
      # i = -1
      # @@clients.each do |c|
        # i += 1
        # break if c == ws
      # end
      # @@users.delete_at(i)
      # @@clients.delete(ws)
    end

    ws.onmessage do |msg|
      puts "Received message: #{msg}"
      # i = -1
      # @@clients.each do |c|
      #   i += 1
      #   break if c == ws
      # end
      # val = JSON.parse(msg)
      # if val['message'] && val['conversation']
      #   Message.new(val['message'], @@users[i], val['conversation'])
      # end
      # @@clients.each do |socket|
      #   socket.send(msg)
      # end
    end
  end

end
