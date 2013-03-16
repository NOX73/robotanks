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
          socket.write "#{you.to_json}}\n"
          alive
        end

      end

      state :live do
        def next_tick
          commands = ActiveSupport::JSON.decode socket.readline
          run_commands commands
          sleep 0.1
        end
      end

      event :alive do
        transition all => :live
      end

    end

    def run_commands(commands)
      commands.each do |key, value|
        self.send key, value
      end
    end

    def do_something
      "#{{message: "hi"}.to_json}\n"
    end

    def you
      {
          you: {
              id: id
          }
      }
    end

    def move(val)
      world.mailbox << Message.new(:move, id, val)
    end

  end
end

