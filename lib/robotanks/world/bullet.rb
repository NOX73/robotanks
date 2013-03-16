module Robotanks
  class World::Bullet < World::WorldObject
    def move_speed; 150 end
    def speed; 1 end

    def initialize(bot, *params)
      @bot = bot
      super *params
    end

    def belongs_to?(bot)
      @bot == bot
    end

  end
end
