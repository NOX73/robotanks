module Robotanks
  class Client::Observer

    def do_something
      json = {
          map: {
              x: 1000,
              y: 1000
          },
          bots: [
            {x: 100 , y: 100},
            {x: 300 , y: 300},
            {x: 400 , y: 400},
          ]
      }.to_json
      "#{json}\n"
    end

  end
end
