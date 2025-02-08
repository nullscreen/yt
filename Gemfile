source 'https://rubygems.org'

# Specify your gem's dependencies in yt.gemspec
gemspec

not_jruby = %i[ruby mingw x64_mingw].freeze

# We add non-essential gems like debugging tools and CI dependencies
# here. This also allows us to use conditional dependencies that depend on the
# platform
gem 'pry', platforms: not_jruby
gem 'simplecov'
gem 'simplecov-cobertura'
gem 'yard'
