module Robotanks
  class TankoBot::WorldReader
    include Celluloid

    attr_reader :socket, :bot

    def initialize(socket, bot)
      @socket = socket
      @bot = bot

      async.start_read
    end

    def start_read
      loop {
        begin
          world = ActiveSupport::JSON.decode socket.readline
          bot.last_world = world if world && world["map"]
          bot.die && terminate if world && world["message"] && world["message"]["die"]
        rescue MultiJson::LoadError, Errno::ECONNRESET
          #
        end
      }
   end

  end
end
