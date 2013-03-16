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

      role_json = ActiveSupport::JSON.decode socket.readline

      @role = "Robotanks::Client::#{role_json["role"].classify}".constantize.new(socket)

      run_loop
    rescue NameError => e
      close_connection(e)
    end

    def close_connection(reason=nil)
      role.disconnected
      puts "*** #{host}:#{port} disconnected"
      puts "*** reason: #{reason}" if reason
      puts "*** backtrace: #{reason.backtrace}" if reason
    end

    def run_loop
      CommandReader.new(self)
      loop { role.next_tick }
    rescue EOFError, Errno::EPIPE
      close_connection
    end

    def run_commands(commands)
      role.run_commands(commands)
    end

  end
end
