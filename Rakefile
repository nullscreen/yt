require "bundler"
Bundler.setup
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
require "rspec/core/version"

# desc "Run all examples"
# RSpec::Core::RakeTask.new :spec

# @note: During the last 48 hours, YouTube API has being responding with
#   unexpected and undocumented errors to the content-owner endpoints.
#   Since some pull requests are waiting for tests to pass on Travis CI and
#   do not touch the content-owner component at all, those tests are
#   temporarily skipped to allow those PRs to be accepted. This will cause
#   code coverage to go down, but it's a temporary fix waiting for YouTube
#   API to work again.
desc "Run all examples except ones with access to Content Owner"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--tag ~partner'
end

task default: [:spec]