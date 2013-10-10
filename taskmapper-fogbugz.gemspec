require File.expand_path '../lib/provider/version', __FILE__

Gem::Specification.new do |spec|
  spec.name          = "taskmapper-fogbugz"
  spec.version       = TaskMapper::Provider::Fogbugz::VERSION
  spec.authors       = ["Rafael George", "www.hybridgroup.com"]
  spec.email         = ["rafael@hybridgroup.com", "info@hybridgroup.com"]
  spec.description   = %q{A TaskMapper provider for interfacing with Fogbugz.}
  spec.summary       = %q{A TaskMapper provider for interfacing with Fogbugz.}
  spec.homepage      = "http://ticketrb.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'taskmapper'
  spec.add_dependency 'ruby-fogbugz', '~> 0.1'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.0'
  spec.add_development_dependency "webmock", "~> 1.14.0"
  spec.add_development_dependency 'vcr', '~> 2.6.0'
end
