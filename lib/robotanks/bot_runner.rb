module Robotanks
  class BotRunner

    class OptionsParser
      def parse!(args)
        options = {}

        opt_parser = OptionParser.new do |opts|

          opts.on("-p", "--port PORT", "Port for bind") do |port|
            options[:port] = port.to_i
          end

          opts.on("-o", "--host HOST", "bind to HOST") do |host|
            options[:host] = host
          end

        end

        begin
          opt_parser.parse! args
        rescue OptionParser::InvalidOption => e
          warn e.message
          abort opt_parser.to_s
        end

        options
      end
    end

    def default_options
      {
        :port     => 4444,
        :host     => "127.0.0.1"
      }
    end

    attr_reader :argv

    def initialize(argv)
      @argv = argv
    end

    def run
      trap_signals
      run_bot
    rescue StandardError => e
      puts e
      puts e.backtrace
    end

    def run_bot
      bot.run
    rescue Exception => e
      @socket.close unless @socket.closed?
      p e
      p e.backtrace
    ensure
      respawn if options[:respawn]
    end

    def respawn
      @bot = nil
      @socket = nil
      run_bot
    end

    def socket
      @socket ||= begin
        s = Celluloid::IO::TCPSocket.new options[:host], options[:port]
        RTSocket.new s
      end
    end

    def options
      @options ||=  begin
        options = default_options.dup

        parser = OptionsParser.new
        options.update parser.parse!(argv)

        options
      end
    end

    def bot
      @bot ||= TankoBot.new(socket)
    end

    def trap_signals
      Signal.trap("INT")  {
        puts "*** Bye"
        `kill -9 #{Process.pid}`
      }
    end

    def self.run(argv)
      new(argv).run
    end

  end
end
