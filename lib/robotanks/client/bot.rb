module Robotanks
  class Client::Bot < Client::Base

    attr_reader :bot_id

    def initialize(*args)
      super
      @id_future = world.future.add_bot
    end

    state_machine :state, :initial => :init do

      state :init do

        def next_tick
          return unless @id_future.value
          @bot_id =  @id_future.value.id

          socket.write "#{you.to_json}}\n"

          alive
        end

      end

      state :live do
        def next_tick
          socket.write do_something
          sleep 0.1
        end
      end

      event :alive do
        transition all => :live
      end

    end

    def do_something
      "Hi\n"
    end

    def you
      {
          you: {
              id: bot_id
          }
      }
    end

  end
end

