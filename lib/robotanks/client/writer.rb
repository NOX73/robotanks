module Robotanks
  class Client::Writer
    include Celluloid

    attr_reader :socket

    def initialize(socket)
      @socket = socket

      async.write_messages
    end

    def write_messages
      loop {
        hash = receive
        socket.write "#{hash.to_json}\n"
      }
    end

  end
end
