module Robotanks
  class TankoBot::SimpleStrat

    attr_reader :bot, :last_world

    def initialize(bot)
      @bot = bot
    end

    def go

      loop {
        bot.move(1)
        bot.turn_angle(50)
        bot.send_commands

        @last_world = bot.last_world.dup

        check_targets

        sleep 0.5
      }

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

    def check_target(target)
      x = you["x"] - target["x"]
      y = you["y"] - target["y"]

      target_rad = Math.atan(y/x)
      target_grad = radian_to_grad(target_rad)

      you_angle = you["angle"]

      while you_angle > 360
        you_angle -= 360
      end

      while you_angle < 0
        you_angle += 360
      end

      p "#{target["id"]} - #{target_grad} - #{you_angle}"

      bot.fire if you["angle"] - target_grad < 4
    end

    def radian_to_grad(rad)
      (rad * 180) / Math::PI
    end

  end
end
