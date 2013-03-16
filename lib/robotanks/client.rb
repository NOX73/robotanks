module Robotanks
  class Client
    include Celluloid

    autoload :Bot,          'robotanks/client/bot'
    autoload :Observer,     'robotanks/client/observer'

    attr_reader :role, :socket, :host, :port

    def initialize(socket, host, port)
      @socket = socket
      @host = host
      @port = port

      role_str = readline

      @role = "Robotanks::Client::#{role_str.classify}".constantize.new

      run_loop
    rescue NameError
      close_connection
    end

    def close_connection
      puts "*** #{host}:#{port} disconnected"
      socket.close
    end

    def run_loop

      loop {
        socket.write @role.do_something
        sleep 1
      }

    rescue EOFError, Errno::EPIPE
      close_connection
    end

    def readline
      line = ""
      while char = socket.read(1)
        return line.gsub("\r", "") if char == $/
        line << char
      end
    end

  end
end
