module Robotanks
  class CommandReader
    include Celluloid

    attr_reader :client
    def initialize(client)
      @client = client
      async.run_reader
    end

    def run_reader
      loop {
        commands = ActiveSupport::JSON.decode client.socket.readline
        client.run_commands commands
      }
    rescue IOError
      client.close_connection
    end

  end
end
