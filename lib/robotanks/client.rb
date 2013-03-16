module Robotanks
  class Client
    include Celluloid

    autoload :Base,          'robotanks/client/base'
    autoload :Bot,          'robotanks/client/bot'
    autoload :Observer,     'robotanks/client/observer'

    attr_reader :role, :socket, :host, :port

    def initialize(socket, host, port)
      @socket = socket
      @host = host
      @port = port

      role_json = ActiveSupport::JSON.decode readline

      @role = "Robotanks::Client::#{role_json["role"].classify}".constantize.new(socket)

      run_loop
    rescue NameError => e
      close_connection(e)
    end

    def close_connection(reason)
      puts "*** #{host}:#{port} disconnected"
      puts "*** reason: #{reason}"
      puts "*** backtrace: #{reason.backtrace}"
      socket.close
    end

    def run_loop
      loop {
        role.next_tick if world.alive
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

    def world
      Celluloid::Actor[:world]
    end

  end
end
