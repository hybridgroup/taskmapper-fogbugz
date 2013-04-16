# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rafael George"]
  gem.email         = ["rafael@hybridgroup.com"]
  gem.description   = %q{Allows taskmapper to interact with Fogbugz.}
  gem.summary       = %q{Allows taskmapper to interact with Fogbugz.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "taskmapper-fogbugz"
  gem.require_paths = ["lib"]
  gem.version       = TaskMapper::Fogbugz::VERSION

  gem.add_dependency 'taskmapper'
  gem.add_dependency 'rake'
  gem.add_dependency 'ruby-fogbugz', '~> 0.1'

  gem.add_development_dependency 'rspec', '~> 2.0'
  gem.add_development_dependency 'fakeweb', '~> 1.3'
  gem.add_development_dependency 'vcr', '~> 1.11'
  gem.add_development_dependency 'rcov', '~> 1.0'
end
