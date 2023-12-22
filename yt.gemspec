lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yt/version'

Gem::Specification.new do |spec|
  spec.name          = "yt"
  spec.version       = Yt::VERSION
  spec.authors       = ["Claudio Baccigalupo"]
  spec.email         = ["claudio@fullscreen.net"]
  spec.description   = %q{Youtube V3 API client.}
  spec.summary       = %q{Yt makes it easy to interact with Youtube V3 API by
    providing a modular, intuitive and tested Ruby-style API.}
  spec.homepage      = "http://github.com/Fullscreen/yt"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.1'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'

  # For development / Code coverage / Documentation
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  # spec.add_development_dependency 'yard'
  # spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
