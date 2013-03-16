module Robotanks
  class World::Bot

    attr_reader :x, :y, :id

    def initialize(id, x, y)
      @id = id
      @x = x
      @y = y
    end

  end
end
