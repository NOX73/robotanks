module Robotanks
  class Client::Base

    attr_reader :socket, :world

    def initialize(socket)
      @socket = socket
      @world = Celluloid::Actor[:world]

      @quit = false
    end

    def disconnected
      socket.close
    rescue IOError
      #
    end

    def send_world
      socket.write "#{world_hash}\n"
    end

    def world_hash
      world.to_hash
    end

    def bye_hash
      {message: :bye}
    end

    def run_commands(commands)
      return unless commands
      commands.each do |key, value|
        self.send key, value
      end
    end

    def say_bye
      socket.write "#{bye_hash}\n"
    end

    def quit(val)
      return unless val
      @quit = true
      say_bye
      disconnected
    end

    def quit?; @quit end

  end
end
