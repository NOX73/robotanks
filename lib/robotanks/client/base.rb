module Robotanks
  class Client::Base
    include Celluloid

    attr_reader :world, :writer, :reader

    def initialize(reader, writer)
      @world = Celluloid::Actor[:world]
      @writer = writer
      @reader = reader

      async.run_loop
    end

    def run_loop
      loop{ tick }
    end

    def tick
      message = recieve
      process_message(message)
    end

    def process_message(message)
      name = message.name.to_sym
      self.send name, message.params if self.respond_to? name
    end

  end
end
