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

    def close_connection(reason=nil)
      puts "*** #{host}:#{port} disconnected"
      puts "*** reason: #{reason}" if reason
      puts "*** backtrace: #{reason.backtrace}" if reason
      socket.close
    end

    def run_loop
      loop {
        role.next_tick
      }
    rescue EOFError, Errno::EPIPE
      close_connection
    end

  end
end
