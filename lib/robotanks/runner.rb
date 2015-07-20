module Robotanks
  class Runner

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
        :host     => "0.0.0.0"
      }
    end

    attr_reader :argv

    def initialize(argv)
      @argv = argv
    end

    def run
      world_run
      trap_signals
      run_server
    end

    def run_server
      server.run
    end

    def trap_signals
      Signal.trap("INT")  {
        puts "*** Bye"
        kill_self
      }
    end

    def kill_self
      `kill -9 #{Process.pid}`
    end

    def options
      @options ||=  begin
        options = default_options.dup

        parser = OptionsParser.new
        options.update parser.parse!(argv)

        options
      end
    end

    def server
      @server ||= Server.new(options[:host], options[:port])
    end

    def world_run
      #World.supervise_as :world, 1000, 1000
      #Celluloid::Actor[:world].async.run
    end

    def self.run(argv)
      new(argv).run
    end

  end
end