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

  @log = Logger.new(STDOUT)
  @clients = []

  EM::WebSocket.run(:host => '0.0.0.0', :port => '3001') do |ws|
    ws.onopen do |handshake|
      @log.info "Connected :-)"
      @clients << ws
      ws.send "Connected to #{handshake.path}."
    end

    ws.onclose do
      @log.info "WebSocket connection closed."
      @clients.delete ws
    end

    ws.onmessage do |msg|
      puts "Received message: #{msg}"
      @clients.each do |socket|
        socket.send msg
      end
    end
  end

  Thin::Server.start(
    MatchaApp, '0.0.0.0', 4567,
    signals: false
  )
end
