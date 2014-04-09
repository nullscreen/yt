lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'googol/version'

Gem::Specification.new do |spec|
  spec.name          = "googol"
  spec.version       = Googol::VERSION
  spec.authors       = ["Claudio Baccigalupo"]
  spec.email         = ["claudio@fullscreen.net"]
  spec.description   = %q{Google + Youtube V3 API client.}
  spec.summary       = %q{Googol lets you interact with many resources
    provided by Google API V3.}
  spec.homepage      = 'https://github.com/fullscreeninc/googol'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'README.md']

  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.2'
  spec.required_rubygems_version = ">= 1.3.6"

  # For development / Code coverage / Documentation
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'coveralls'
end