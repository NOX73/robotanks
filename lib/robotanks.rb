require "robotanks/version"
require 'celluloid'
require 'celluloid/io'

require 'active_support'
require 'active_support/core_ext'

require 'state_machine'

module Robotanks

  autoload :Runner,     'robotanks/runner'
  autoload :Server,     'robotanks/server'
  autoload :Client,     'robotanks/client'

  autoload :World,     'robotanks/world'

  def self.run(argv)
    Runner.run(argv)
  end

end
