module Robotanks
  class World
    include Celluloid

    attr_reader :width, :height
    attr_reader :bots_n
    attr_reader :bots

    def initialize(width, height)
      @width = width
      @height = height
      @bots_n = 0
      @alive = true
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
      puts "*** new bot: #{@bots_n}"
      @bots_n += 1
    end

  end
end

