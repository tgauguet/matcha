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

    EM::WebSocket.run(:host => '0.0.0.0', :port => '3001') do |ws|

      ws.onopen do |handshake|
        @@clients << ws
        @user = User.find_by("id", handshake.query["key"]).id
        puts "______________ BEGIN ________________"
        puts "@user :"
        puts @user
        puts "@@users before :"
        puts @@users
        @@users << @user
        puts "@@users after :"
        puts @@users
        ws.send("Connected to #{handshake.path} as user N°#{@user}")
        # @log.info("Connected to '#{handshake.path}' as user N°#{@user}")
      end

      ws.onclose do
        puts "__________ ON CLOSE STARTS ___________"
        puts "@user :"
        puts @user
        puts "@@users before :"
        puts @@users
        @@users -= [@user] if @user# == current_user
        puts "@@users after :"
        puts @@users
        # @log.info("WebSocket connection closed.")
        puts "____________ FINISH _________________"
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

  Thin::Server.start(
    MatchaApp, '0.0.0.0', 4567,
    signals: false
  )
end
