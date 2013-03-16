module Robotanks
  class Client
    include Celluloid

    autoload :Bot,          'robotanks/client/bot'
    autoload :Observer,     'robotanks/client/observer'

    attr_reader :role, :socket

    def initialize(socket)
      @socket = socket
      role_str = readline

      @role = "Robotanks::Client::#{role_str.classify}".constantize.new
      run_loop
    end

    def run_loop

      loop {
        socket.write @role.do_something
        sleep 1
      }

    rescue EOFError
      puts "*** #{host}:#{port} disconnected"
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
