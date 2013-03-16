module Robotanks
  class World::Bot < World::WorldObject

    def move_speed; 10 end
    def angle_speed; 10 end

    attr_reader :id, :time, :new_angle


    def initialize(id, x, y)
      @id = id
      @new_angle = 0

      super x, y

      puts "*** new bot: #{id}"
    end

    def calc_params
      move_angle
      super
    end

    def move_angle
      return if (new_angle - angle).abs < 0.1
      f = new_angle > angle ? 1 : -1
      @angle += time_factor * angle_speed * f
    end

    def turn_angle(val)
      @new_angle = @angle + val
    end

  end
end
