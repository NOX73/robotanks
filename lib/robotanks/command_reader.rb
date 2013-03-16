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
        break if client.socket.closed?

        begin
          commands = ActiveSupport::JSON.decode client.socket.readline
        rescue MultiJson::LoadError
          commands = {}
        end

        client.run_commands commands
      }
    rescue IOError, Errno::EBADF, Errno::ECONNRESET
      client.close_connection
    end

  end
end
