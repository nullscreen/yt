require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start

ENV['YT_TEST_CLIENT_ID'] ||= 'XXX'
ENV['YT_TEST_CLIENT_SECRET'] ||= 'YYY'
ENV['YT_TEST_API_KEY'] ||= 'ZZZ'
ENV['YT_TEST_REFRESH_TOKEN'] ||= 'ABC'

Dir['./spec/support/**/*.rb'].each {|f| require f}

RSpec.configure do |config|
  config.order = 'random'
  config.run_all_when_everything_filtered = false
  # @note: Some tests might take too long to run on Ruby 1.9.3 which does not
  #   support "size" for Enumerator, so we are better off skipping them.
  config.filter_run_excluding ruby2: true if RUBY_VERSION < '2'
  # @note: See https://github.com/Fullscreen/yt/issues/103
  config.filter_run_excluding ruby21: true if RUBY_VERSION < '2.1'
end
