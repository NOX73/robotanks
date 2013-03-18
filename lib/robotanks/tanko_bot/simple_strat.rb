module Robotanks
  class TankoBot::SimpleStrat

    attr_reader :bot, :last_world

    def initialize(bot)
      @bot = bot
    end

    def go

        bot.move(1)

       loop {

        @last_world = bot.last_world.dup if bot.last_world.present?

        if @last_world
          target = get_target

          if target
            bot.move(rand)

            diff = diff_angle_to_target(target)
            bot.turn_angle(diff)

            bot.fire if diff.abs < 3
          else
            bot.move(0)
            sleep 0.5
          end

        end

        bot.send_commands

        sleep 0.01
      }

    end

    def get_target
      last_world["bots"].select{|b|
        b["id"] != you["id"]
      }.first
    end

    def check_targets
      return unless last_world["bots"]
      last_world["bots"].each do |b|
        check_target(b) if b["id"] != you["id"]
      end
    end

    def you
      last_world["you"]
    end

    def you_angle

      you_angle = you["angle"]

      while you_angle > 360
        you_angle -= 360
      end

      while you_angle < 0
        you_angle += 360
      end

      you_angle = 360 - you_angle

      you_angle
    end

    def check_target(target)

    end

    def angle_to_target(target)
      x = target["x"] - you["x"]
      y = target["y"] - you["y"]

      target_rad = Math.atan(y/x)
      target_grad = radian_to_grad(target_rad)

      target_grad = 360 - target_grad if x > 0 && y > 0
      target_grad = -target_grad if x > 0 && y < 0
      target_grad = 180 - target_grad if x < 0 && y < 0
      target_grad = 180 - target_grad if x < 0 && y > 0

      target_grad
    end

    def diff_angle_to_target(target)
      diff = you_angle - angle_to_target(target)
      if diff.abs > 180
        diff = diff > 0 ? diff - 360 : 360 - diff
      end
      p "#{diff} = #{you_angle} - #{angle_to_target(target)}"
      diff
    end

    def radian_to_grad(rad)
      (rad * 180) / Math::PI
    end

  end
end
