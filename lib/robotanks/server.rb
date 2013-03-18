module Robotanks
  class Server
    include Celluloid::IO

    def initialize(host, port)
      puts "*** Starting echo server on #{host}:#{port}"

      @server = TCPServer.new(host, port)
      run
    end

    def run
      loop { handle_connection! @server.accept }
    end

    def handle_connection(socket)
      socket = RTSocket.new(socket)
      _, port, host = socket.peeraddr

      puts "*** Received connection from #{host}:#{port}"

      init_client(socket)
    end

    def init_client(socket)
      client = Client.new(socket)
      link client
    end

    trap_exit :actor_died
    def actor_died(actor, reason)
      puts "*** Terminated client #{actor.inspect}. Reason: #{reason.class}"
    end

  end
end
