module Robotanks
  class Client::Observer < Client::Base


    def do_something
      "#{world.to_hash.to_json}\n"
    end

  end
end
