module Robotanks
  class World::WorldObject
    def move_speed; 0 end
    attr_reader :id, :angle, :time, :new_angle

    attr_accessor :speed, :x, :y, :prev_x, :prev_y

    def initialize(id, x, y, angle=0, speed=0)
      @id = id
      @x = x
      @y = y
      @angle = angle
      @speed = speed
    end

    def calc_params
      save_previous_params
      move
    end

    def save_previous_params
      @prev_x = @x
      @prev_y = @y
    end

    def move
      return if speed.zero?

      @x += speed * Math.cos(radian_angle(angle)) * time_factor * move_speed
      @y += speed * Math.sin(radian_angle(angle)) * time_factor * move_speed

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
