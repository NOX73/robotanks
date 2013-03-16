require "robotanks/version"
require 'celluloid'
require 'celluloid/io'

module Robotanks

  autoload :Runner,     'robotanks/runner'
  autoload :Server,     'robotanks/server'

  def self.run(argv)
    Runner.run(argv)
  end

end
