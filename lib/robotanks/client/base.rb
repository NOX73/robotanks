module Robotanks
  class Client::Base

    attr_reader :socket, :world

    def initialize(socket)
      @socket = socket
      @world = Celluloid::Actor[:world]
    end

    def disconnected
      socket.close
    rescue IOError
      #
    end

    def send_world
      socket.write "#{world.to_hash.to_json}\n"
    end

    def run_commands(commands)
      return unless commands
      commands.each do |key, value|
        self.send key, value
      end
    end


  end
end
