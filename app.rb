require "./config/app.rb"
require 'base64'
require 'cgi'

EM.run do

  # hit Control + C to stop
  Signal.trap("INT")  {
    puts "Shutting down"
    EventMachine.stop
  }

  Signal.trap("TERM") {
    puts "Shutting down"
    EventMachine.stop
  }

  class MyWS

    @log = Logger.new(STDOUT)
    @@clients = []
    @@users = []

    def self.users
      @@users
    end

    EM::WebSocket.run(:host => '0.0.0.0', :port => '3001') do |ws|

      ws.onopen do |handshake|
        @@clients << ws
        @user = User.find_by("id", handshake.query["key"]).id

        @@users << @user if @user
        ws.send("Connected to #{handshake.path} as user N°#{@user}")
        @log.info("Connected to '#{handshake.path}' as user N°#{@user}")
      end

      ws.onclose do
        @@users -= [@user] if @@users && @user
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
  end

  Thin::Server.start(
    MatchaApp, '0.0.0.0', 4567,
    signals: false
  )
end
