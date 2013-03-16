module Robotanks
  class Client::Observer < Client::Base

    def next_tick
      send_world
      sleep 0.1
    end

  end
end
