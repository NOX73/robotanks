module Robotanks
  class World::Bot < World::WorldObject

    def move_speed; 40 end
    def angle_speed; 10 end
    def turret_angle_speed; 100 end
    def max_ammo; 2 end
    def restore_ammo_speed; 1 end

    attr_reader :time, :new_angle, :cur_ammo, :alive,
                :turret_angle, :new_turret_angle

    def initialize(id, x, y)
      @new_angle = 0
      @cur_ammo = max_ammo
      @alive = true

      @turret_angle = 0
      @new_turret_angle = 0

      super id, x, y

      puts "*** new bot: #{id}"
    end

    def calc_params
      move_angle
      restore_ammo
      move_turret
      super
    end

    def move_angle
      return @angle = new_angle if (new_angle - angle).abs < 0.1
      f = new_angle > angle ? 1 : -1
      @angle += time_factor * angle_speed * f
    end

    def turn_angle(val)
      @new_angle = @angle + val
    end

    def restore_ammo
      return if @cur_ammo == max_ammo
      @cur_ammo += restore_ammo_speed * time_factor
      @cur_ammo = max_ammo if @cur_ammo > max_ammo
    end

    def fire(id)
      return unless can_fire?
      @cur_ammo -= 1

      World::Bullet.new(self, id, x, y, @angle)
    end

    def can_fire?
      max_ammo >= 1
    end

    def die
      @alive = false
    end

    def alive?; @alive end

    def turn_turret(val)
      @new_turret_angle = @turret_angle + val
    end

    def move_turret
      return @turret_angle = new_turret_angle if (new_turret_angle - turret_angle).abs < 0.1
      f = new_turret_angle > turret_angle ? 1 : -1
      @turret_angle += time_factor * turret_angle_speed * f
    end

  end
end
