module Robotanks
  class Runner

    def initialize(args)
      @server = Server.new('0.0.0.0', 4444)
    end

    def run
      @server.run
    end

    def self.run(argv)
      new(argv).run
    end

  end
end