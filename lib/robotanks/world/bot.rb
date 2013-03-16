module Robotanks
  class World::Bot
    MOVE_SPEED = 10
    ANGLE_SPEED = 10

    attr_reader :x, :y, :id, :angle, :time, :new_angle

    attr_accessor :speed

    def initialize(id, x, y)
      @id = id
      @x = x
      @y = y
      @angle = 0
      @new_angle = 0
      @speed = 0

      puts "*** new bot: #{id}"
    end

    def calc_params
      move_angle
      move
    end

    def move
      return if speed.zero?

      @x += speed * Math.cos(radian_angle) * time_factor * MOVE_SPEED
      @y += speed * Math.sin(radian_angle) * time_factor * MOVE_SPEED

    end

    def move_angle
      return if (new_angle - angle).abs < 0.1
      f = new_angle > angle ? 1 : -1
      @angle += time_factor * ANGLE_SPEED * f
    end

    def time=(val)
      @old_time = @time || val
      @time = val
    end

    def time_factor
      @time - @old_time
    end

    def turn_angle(val)
      @new_angle = @angle + val
    end

    def radian_angle
      angle / Math::PI / 180
    end

  end
end
