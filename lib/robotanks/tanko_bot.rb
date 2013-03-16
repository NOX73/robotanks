module Robotanks
  class TankoBot
    autoload :SimpleStrat,  'robotanks/tanko_bot/simple_strat'
    autoload :WorldReader,  'robotanks/tanko_bot/world_reader'

    attr_reader :socket, :world_reader
    attr_accessor :last_world

    def initialize(socket)
      @socket = socket
      @world_reader = WorldReader.new socket, self
      @last_world = {}

      introduce
    end

    def run
      strat = SimpleStrat.new self
      strat.go
    end

    def commands
      @commands ||= {}
    end

    def move(val)
      commands[:move] = val
    end

    def turn_angle(val)
      commands[:turn_angle] = val
    end

    def fire
      p "*** FIRE!!!"
      commands[:fire] = true
    end

    def send_commands
      send_hash(commands)

      reset_commands
    end

    #def get_last_world
    #  feature = world_reader.feature.last_world
    #
    #  while feature.value.nil?
    #    sleep 0.1
    #  end
    #
    #  feature.value
    #end

    def reset_commands
      @commands = {}
    end

    def introduce
      send_hash(introduce_hash)
    end

    def introduce_hash
      {role: :bot}
    end

    def send_hash(hash)
      socket.write "#{hash.to_json}\n"
    end

  end
end
