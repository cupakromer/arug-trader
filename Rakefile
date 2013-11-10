require "bundler/gem_tasks"

require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'coveralls/rake/task'

Coveralls::RakeTask.new
task :test_with_coveralls => [:spec, :features, 'coveralls:push']

Cucumber::Rake::Task.new(:cucumber)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = '--format doc --require spec_helper'
end

desc 'Default: Run specs.'
task default: [:spec, :cucumber, 'coveralls:push']
