module Robotanks
  class Client
    include Celluloid

    autoload :Base,          'robotanks/client/base'

    autoload :Bot,          'robotanks/client/bot'
    autoload :Observer,     'robotanks/client/observer'

    autoload :Reader,     'robotanks/client/reader'
    autoload :Writer,     'robotanks/client/writer'

    attr_reader :name
    attr_reader :socket, :host, :port
    attr_reader :writer, :reader, :socket
    attr_reader :role

    def initialize(socket)
      @died = false

      @socket = socket
      _, @port, @host = socket.peeraddr
      @name = "#{@host}:#{@port}"

      async.run_loop
    end

    def died?; @died end

    def tick
      message = receive
      process_message(message) if message
    end

    def process_message(message)
      case message.name
        when "role"
          set_role(message.params) unless role
        when "message"
          log_message(message.params)
        else
          role.mailbox << message if role
      end
    end

    def set_role(role)
      @role = "Robotanks::Client::#{role.classify}".constantize.new(name, reader, writer)
      link @role
    end

    def log_message(message)
      puts "*** #{name} send message: #{message}"
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
      puts e
      e.backtrace.each{|b|puts b}
      die
    end

    def die
      return if died?
      @died = true

      puts "*** Die client #{host}:#{port}."

      writer.terminate if writer.alive?
      reader.terminate if reader.alive?
      role.terminate if role && role.alive?

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
