module Robotanks
  class Client::Observer

    def do_something
      json = {
          map: {
              width: 1000,
              height: 1000
          },
          bots: [
            {id: 1, x: 100 , y: 100},
            {id: 2, x: 300 , y: 300},
            {id: 3, x: 400 , y: 400},
          ]
      }.to_json
      "#{json}\n"
    end

  end
end
