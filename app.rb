require "./config/app.rb"

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

  class MyWS < ApplicationController
    @log = Logger.new(STDOUT)
    @@clients = []
    @@users = []

    def self.users
      @@users
    end

    EM::WebSocket.run(:host => '0.0.0.0', :port => '3001') do |ws|

      ws.onopen do |handshake|
        @@clients << ws

        @@users << @user if @user
        puts handshake.path
        puts handshake.headers
        puts handshake.query
        puts handshake.origin
        ws.send("Connected to #{handshake.path}.")
        @log.info("Connected to #{handshake.path}")
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
