module Robotanks
  class Geometry::Square

    class << self
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
