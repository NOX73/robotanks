module Robotanks
  class Client::Base
    include Celluloid

    attr_reader :world
    attr_reader :client_name
    attr_reader :writer, :reader

    def initialize(client_name, reader, writer)
      @world = Celluloid::Actor[:world]
      @client_name = client_name

      @writer = writer
      @reader = reader

      puts "*** #{client_name} set role Bot"

      async.run_loop
    end

    def run_loop
      loop{ tick }
    end

    def tick
      message = receive
      process_message(message)
    end

    def process_message(message)
      command = message.name.to_sym
      puts "*** #{client_name} receive command #{command}"
      if self.respond_to? command
        self.send command, message.params
      else
        puts "*** #{client_name} receive unknown command #{command}. Params: #{message.params}"
      end
    end

  end
end
