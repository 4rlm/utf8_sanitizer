require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'utf8_sanitizer'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

task :console do
  require 'irb'
  require 'irb/completion'
  require 'utf8_sanitizer' # You know what to do.
  require "active_support/all"
  ARGV.clear
  Utf8Sanitizer.run_wrap
  IRB.start
end
