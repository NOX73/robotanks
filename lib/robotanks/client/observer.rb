module Robotanks
  class Client::Observer

    def do_something
      json = {
          map: {
              x: 1,
              y: 1
          }
      }.to_json
      "#{json}\n"
    end

  end
end
