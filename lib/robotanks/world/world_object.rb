module Robotanks
  class World::WorldObject
    def move_speed; 0 end
    attr_reader :x, :y, :angle, :time, :new_angle

    attr_accessor :speed

    def initialize(x, y, angle=0, speed=0)
      @x = x
      @y = y
      @angle = angle
      @speed = speed
    end

    def calc_params
      move
    end

    def move
      return if speed.zero?

      @x += speed * Math.sin(radian_angle(angle)) * time_factor * move_speed
      @y += speed * Math.cos(radian_angle(angle)) * time_factor * move_speed

    end

    def time=(val)
      @old_time = @time || val
      @time = val
    end

    def time_factor
      @time - @old_time
    end

    def radian_angle(angle)
      (angle * Math::PI) / 180
    end

  end
end
