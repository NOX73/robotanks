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
          initial_x = v.x
          initial_y = v.y
          v.x = (initial_x * Math.cos(angle) - initial_y * Math.sin(angle)).abs
          v.y = (initial_x * Math.sin(angle) + initial_y * Math.cos(angle)).abs
          v
        }
      end

      # проверяем попадание снаряда в бота
      def check_hit(point, bot, bot_width, bot_height)
        square = make_square(bot, bot_width, bot_height)
        contains_point?(point, turn_on_angle(square, bot.radian_angle(bot.angle))) ||
          check_circle(point, bot,0.8*bot_width)
      end

      # простой метод попадает ли точка в окружность
      def check_circle(point, bot, radius)
        (point.x - bot.x)*(point.x - bot.x) + (point.y - bot.y)*(point.y - bot.y) < radius * radius
      end

      def check_intersection_by_shoot(bullet, bot, radius)
        a = (bullet.x - bullet.prev_x)*(bullet.x - bullet.prev_x)+(bullet.y - bullet.prev_y)*(bullet.y - bullet.prev_y)
        b = 2*((bullet.x-bullet.prev_x)*(bullet.prev_x-bot.x)+(bullet.y-bullet.prev_y)*(bullet.prev_y-bot.y))
        c = bot.x*bot.x + bot.y*bot.y + bullet.prev_x*bullet.prev_x + bullet.prev_y*bullet.prev_y - 
          2*(bot.x*bullet.prev_x+bot.y*bullet.prev_y) - radius*radius
        if (b < 0)
          c < 0
        elsif ( -b < (2*a))
          (4*a*c-b*b) < 0
        else
          a + b + c < 0
        end
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
