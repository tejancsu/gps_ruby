$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'gps/version'

Gem::Specification.new do |s|
  s.name        = 'gps'
  s.version     = Gps::Version.to_s
  s.summary     = 'GPS v2 Ruby client library.'
  s.description = 'An API client library for GPS (v2).'

  s.required_ruby_version = '>= 1.8.6'

  s.author   = 'Kill Bill team'
  s.email    = 'killbill@groupon.com'
  s.homepage = 'https://wiki.groupondev.com/Kill_Bill'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options << '--exclude' << '.'

  # Versions match orders' Gemfile

  s.add_dependency 'activesupport', '2.3.2'
  s.add_dependency 'json', '1.2.4'
  s.add_dependency 'mime-types', '1.18'
  s.add_dependency 'typhoeus', '0.2.4'

  s.add_development_dependency 'rake', '>= 10.0.0'
  s.add_development_dependency 'rspec', '~> 2.12.0'
  s.add_development_dependency 'uuidtools', '2.1.2'
end
