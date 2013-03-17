# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'robotanks/version'

Gem::Specification.new do |gem|
  gem.name          = "robotanks"
  gem.version       = Robotanks::VERSION
  gem.authors       = ["Rozhnov Alexandr"]
  gem.email         = ["nox73@ya.ru"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency('celluloid')
  gem.add_runtime_dependency('celluloid-io')

  gem.add_runtime_dependency('activesupport')

  gem.add_runtime_dependency('state_machine')
  gem.add_runtime_dependency('state_machine')

end
