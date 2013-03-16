module Robotanks
  class World
    include Celluloid

    autoload :Bot,     'robotanks/world/bot'
    autoload :WorldObject,     'robotanks/world/world_object'
    autoload :Bullet,     'robotanks/world/bullet'

    attr_reader :width, :height
    attr_reader :bots_n
    attr_reader :bots, :bullets

    def initialize(width, height)
      @width = width
      @height = height
      @bots_n = 0
      @alive = true
      @bots = []
      @bullets = []

      async.wait_messages
    end

    def run
      next_tick
    end

    def next_tick

      time = Time.now.to_f

      process_bots(time)
      process_bullets(time)

      after(0.01){
        next_tick
      }
    end

    def process_bullets(time)
      bullets.each do |b|
        b.time = time
        b.calc_params
        fix_bullets_position(b)
       end
    end

    def process_bots(time)
      bots.each do |b|
        b.time = time
        b.calc_params
        fix_bot_position(b)
      end
    end

    def fix_bullets_position(bullet)
      remove_bullet(bullet) if bullet.x > width || bullet.x < 0 || bullet.y > height || bullet.y < 0
    end

    def fix_bot_position(bot)
      bot.x = width if bot.x > width
      bot.x = 0 if bot.x < 0
      bot.y = height if bot.y > height
      bot.y = 0 if bot.y < 0
    end

    def generate_bot_id
      @bots_n += 1
    end

    def wait_messages
      loop {
        receive { |msg|
          self.send msg.name, *msg.params
        }
      }
    end

    def add_bot(bot_id)
      bot = Bot.new(bot_id, Random.rand(100..500), Random.rand(100..500))
      bots << bot
      bot
    end

    def remove_bot(bot_id)
      bots.delete bot_by_id(bot_id)
    end

    def remove_bullet(bullet)
      bullets.delete bullet
    end

    def to_hash
      hash = {}

      hash[:map] = {
              width: width,
              height: height,
              bot_width: 10,
              bot_height: 10
      }

      hash[:bots] = bots.map { |bot|
        {
            id: bot.id,
            x: bot.x,
            y: bot.y,
            angle: bot.angle
        }
      }

      hash[:bullets] = bullets.map {|bullet|
        {
            x: bullet.x,
            y: bullet.y
        }
      }

      hash
    end

    def bot_by_id(bot_id)
      bots.select{ |b|b.id == bot_id }.first
    end

    def move(bot_id, val=1)
      return unless (-1..1).include?(val)
      bot_by_id(bot_id).speed = val
    end

    def turn_angle(bot_id, val=0)
      bot_by_id(bot_id).turn_angle val
    end

    def fire(bot_id, val=true)
      return unless val
      bot = bot_by_id(bot_id)
      bullet = Bullet.new(bot.x, bot.y, bot.angle)
      bullets << bullet
    end

  end
end

