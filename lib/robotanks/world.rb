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
    end

    def run
      next_tick
    end

    def next_tick

      after(0.1){
        next_tick
      }

    end

    def add_bot
      bot = Bot.new(@bots_n, 100, 100)
      bots << bot
      puts "*** new bot: #{bot.id}"
      @bots_n += 1
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

  end
end

