module Robotanks
  class Client::Bot < Client::Base

    attr_reader :id

    def initialize(*args)
      super
      @id = world.generate_bot_id

      world.mailbox << Message.new(:add_bot, @id)
    end

    state_machine :state, :initial => :init do

      state :init do

        def next_tick
          socket.write "#{you.to_json}\n"
          alive
        end

      end

      state :live do
        def next_tick
          send_world
          sleep 10
       end
      end

      event :alive do
        transition all => :live
      end

    end

    def you
      {
          you: {
              id: id
          }
      }
    end

    def disconnected
      world.mailbox << Message.new(:remove_bot, @id)
      super
    end

    def move(val)
      world.mailbox << Message.new(:move, id, val)
    end

    def turn_angle(val)
      world.mailbox << Message.new(:turn_angle, id, val)
    end

  end
end

