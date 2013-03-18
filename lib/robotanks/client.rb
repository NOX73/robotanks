module Robotanks
  class Client
    include Celluloid

    autoload :Base,          'robotanks/client/base'

    autoload :Bot,          'robotanks/client/bot'
    autoload :Observer,     'robotanks/client/observer'

    autoload :Reader,     'robotanks/client/reader'
    autoload :Writer,     'robotanks/client/writer'

    attr_reader :writer, :reader, :socket

    def initialize(socket)
      @died = false

      @socket = socket
      async.run_loop
    end

    def died?; @died end

    def tick
      message = receive
      process_message(message) if message
    end

    def process_message(message)
      case message.name
        when "role" then
          set_role(message.params)
          receive_command
        else
          role.mailbox << message
      end
    end

    def set_role(role)
      @role = "Robotanks::Client::#{role.classify}".constantize.new_link(reader, writer)
    end

    def set_links
      @writer = Client::Writer.new(socket)
      @reader = Client::Reader.new(socket, Actor.current)

      link writer
      link reader

      reader.async.read_messages
    end

    def run_loop
      set_links
      loop{ tick }
    rescue Exception => e
      p e
      p e.backtrace
      die
    end

    def die
      return if died?
      @died = true

      writer.terminate if writer.alive?
      reader.terminate if reader.alive?

      _, port, host = socket.peeraddr
      puts "*** Die client #{host}:#{port}."
      socket.close unless socket.closed?

      terminate
    end

    trap_exit :actor_died
    def actor_died(actor, reason)
      puts "*** Actor: #{actor.inspect}. Reason: #{reason.class}"
      die
    end

  end
end
