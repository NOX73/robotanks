module Robotanks
  class Client::Bot < Client::Base

    attr_reader :id

    def initialize(*args)
      super
      @id = world.generate_object_id

      world.mailbox << Message.new(:add_bot, @id)
    end

    state_machine :state, :initial => :init do

      state :init do

        def next_tick
          return sleep 0.1 unless bot
          socket.write "#{you.to_json}\n"
          alive
        end

      end

      state :live do
        def next_tick
          die unless am_i_alive?
          send_world unless socket.closed?
          sleep 0.1
       end
      end

      event :alive do
        transition all => :live
      end

    end

    def bot
      @bot ||= world.bot_by_id(self.id)
    end

    def die
      @quit = true
      p "*** Bot #{id}: You're dead"
      say_die unless socket.closed?
      disconnected
    end

    def say_die
      socket.write "#{die_hash.to_json}\n"
    end

    def die_hash
      {message: :die}
    end

    def am_i_alive?
      bot.alive?
    end

    def you
      bot = world.bot_by_id(id)
      return {} unless bot

      {
          you: {
              id: bot.id,
              x: bot.x,
              y: bot.y,
              angle: bot.angle,
              cur_ammo: bot.cur_ammo,
              turret_angle: bot.turret_angle
          }
      }
    end

    def world_hash
      hash = world.to_hash
      hash.merge!(you)
    end

    def disconnected
      world.mailbox << Message.new(:remove_bot, id)
      super
    end

    def move(val)
      world.mailbox << Message.new(:move, id, val)
    end

    def turn_angle(val)
      world.mailbox << Message.new(:turn_angle, id, val)
    end

    def fire(val)
      world.mailbox << Message.new(:fire, id, val)
    end

    def turn_turret(val)
      world.mailbox << Message.new(:turn_turret, id, val)
    end

  end
end

