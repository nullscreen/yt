lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yt/version'

Gem::Specification.new do |spec|
  spec.name          = "yt"
  spec.version       = Yt::VERSION
  spec.authors       = ["Nullscreen"]
  spec.email         = ["nullscreen.code@gmail.com"]
  spec.description   = %q{Youtube V3 API client.}
  spec.summary       = %q{Yt makes it easy to interact with Youtube V3 API by
    providing a modular, intuitive and tested Ruby-style API.}
  spec.homepage      = "http://github.com/nullscreen/yt"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.1'


  spec.files = Dir['lib/**/*.rb', '*.md', '*.txt', '.yardopts', 'MIT-LICENSE']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
