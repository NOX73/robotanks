module Robotanks
  class World::Bot

    attr_reader :x, :y, :id, :angle

    attr_accessor :speed

    def initialize(id, x, y)
      @id = id
      @x = x
      @y = y
      @angle = 0
      @speed = 0

      puts "*** new bot: #{id}"
    end

    def move
      return if speed.zero?

      @x += speed * Math.cos(angle)
      @y += speed * Math.sin(angle)

    end

  end
end
