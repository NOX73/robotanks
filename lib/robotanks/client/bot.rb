module Robotanks
  class Client::Bot < Client::Base

    attr_reader :id

    def initialize(*args)
      super
      #async.add_to_world
    end

    def add_to_world
      world.mailbox << Message.new(:add_bot, self)
    end

    def bot
      @bot ||= world.bot_by_id(self.id)
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

    def name(val)
      world.mailbox << Message.new(:name, id, val)
    end

  end
end

