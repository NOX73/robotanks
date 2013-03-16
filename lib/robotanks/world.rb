module Robotanks
  class World
    include Celluloid

    autoload :Bot,     'robotanks/world/bot'

    attr_reader :width, :height
    attr_reader :bots_n
    attr_reader :bots

    def initialize(width, height)
      @width = width
      @height = height
      @bots_n = 0
      @alive = true
      @bots = []

      async.wait_messages
    end

    def run
      next_tick
    end

    def next_tick

      bots.each do |b|
        b.move
      end

      after(0.1){
        next_tick
      }

    end

    def generate_bot_id
      @bots_n += 1
    end

    def wait_messages
      loop {
        receive { |msg|
          self.send msg.name, *msg.params
        }
      }
    end

    def add_bot(bot_id)
      bot = Bot.new(bot_id, Random.rand(100..500), Random.rand(100..500))
      bots << bot
      bot
    end

    def to_hash
      hash = {}

      hash[:map] = {
              width: width,
              height: height,
              bot_width: 10,
              bot_height: 10
      }

      hash[:bots] = bots.map { |bot|
        {
            id: bot.id,
            x: bot.x,
            y: bot.y
        }
      }

      hash
    end

    def move(bot_id, val=1)
      bot = bots.select{ |b|b.id == bot_id }.first
      bot.speed = val
    end

  end
end

