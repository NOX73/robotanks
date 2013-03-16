module Robotanks
  class Server
    include Celluloid::IO

    def initialize(host, port)
      puts "*** Starting echo server on #{host}:#{port}"

      @server = TCPServer.new(host, port)
      run
    end

    def finalize
      @server.close if @server
    end

    def run
      loop { handle_connection! @server.accept }
    end

    def handle_connection(socket)
      socket = RTSocket.new(socket)
      _, port, host = socket.peeraddr
      puts "*** Received connection from #{host}:#{port}"
      client = Client.new(socket, host, port)
    rescue EOFError
      puts "*** #{host}:#{port} disconnected"
    end

  end
end
