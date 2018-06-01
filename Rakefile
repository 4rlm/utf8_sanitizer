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
  # sanitized_data = Utf8Sanitizer.sanitize(file_path: "./lib/utf8_sanitizer/csv/seeds_mini.csv")
  sanitized_data = Utf8Sanitizer.sanitize
  IRB.start
end
