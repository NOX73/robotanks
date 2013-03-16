module Robotanks
  class Geometry::Square

    class << self

      # делаем квадрат Point'ов из бота и его размерности
      def make_square(bot, bot_width, bot_height)
        #bissek = Math.sqrt(2) * (bot_width * bot_height) / (bot_width + bot_height)
        delta_width = bot_width / 2
        delta_height = bot_height / 2
        lh = Geometry::Point.new(bot.x - delta_width, bot.y - delta_height)
        ll = Geometry::Point.new(bot.x - delta_width, bot.y + delta_height)
        rh = Geometry::Point.new(bot.x + delta_width, bot.y - delta_height)
        rl = Geometry::Point.new(bot.x + delta_width, bot.y + delta_height)
        [lh, ll, rh, rl]
      end

      def turn_on_angle(square, angle)
        square.map { |v| 
          v.x = v.x * Math.cos(angle) - v.y * Math.sin(angle)
          v.y = v.x * Math.sin(angle) + v.y * Math.cos(angle)
          v
        }
      end

      # проверяем попадание снаряда в бота
      def check_hit(point, bot, bot_width, bot_height)
        square = make_square(bot, bot_width, bot_height)
        contains_point?(point, turn_on_angle(square, bot.radian_angle(bot.angle)))
      end

      # проверяем попадание точки в заданную область
      def contains_point?(point, poly)
        c = false
        i = -1
        j = poly.size - 1
        while (i += 1) < poly.size
          if ((poly[i].y <= point.y && point.y < poly[j].y) || (poly[j].y <= point.y && point.y < poly[i].y))
            if (point.x < (poly[j].x - poly[i].x) * (point.y - poly[i].y) / (poly[j].y - poly[i].y) + poly[i].x)
              c = !c
            end
            j = i
          end
        end
        c
      end
    end
  end
end
