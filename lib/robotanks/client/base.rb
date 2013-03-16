module Robotanks
  class Client::Base

    attr_reader :socket, :world

    def initialize(socket)
      @socket = socket
      @world = Celluloid::Actor[:world]
    end

    def next_tick
      socket.write do_something
      sleep 0.1
    end

  end
end
