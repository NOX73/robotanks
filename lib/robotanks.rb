require "robotanks/version"
require 'celluloid'
require 'celluloid/io'

require 'active_support'
require 'active_support/core_ext'

module Robotanks

  autoload :Runner,     'robotanks/runner'
  autoload :Server,     'robotanks/server'
  autoload :Client,     'robotanks/client'

  def self.run(argv)
    Runner.run(argv)
  end

end
