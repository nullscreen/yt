require 'simplecov'

if ENV['CI']
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
else
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

SimpleCov.start do
  enable_coverage :branch
  add_filter '/spec/'
  add_filter '/vendor/'
end

ENV['YT_TEST_CLIENT_ID'] ||= 'XXX'
ENV['YT_TEST_CLIENT_SECRET'] ||= 'YYY'
ENV['YT_TEST_API_KEY'] ||= 'ZZZ'
ENV['YT_TEST_REFRESH_TOKEN'] ||= 'ABC'

ENV['YT_TEST_CONTENT_OWNER_NAME'] ||= 'abcd'
ENV['YT_TEST_PARTNER_CLIENT_ID'] ||= 'abcd'
ENV['YT_TEST_PARTNER_CLIENT_SECRET'] ||= 'abcd'
ENV['YT_TEST_CONTENT_OWNER_REFRESH_TOKEN'] ||= 'abcd'
ENV['YT_TEST_CONTENT_OWNER_ACCESS_TOKEN'] ||= 'abcd'

Dir['./spec/support/**/*.rb'].each {|f| require f}

RSpec.configure do |config|
  config.order = 'random'
  config.run_all_when_everything_filtered = false
end
