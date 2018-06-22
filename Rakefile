require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'utf8_sanitizer'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

task :console do
  require 'irb'
  require 'irb/completion'
  require 'utf8_sanitizer'
  require "active_support/all"
  ARGV.clear
  orig_hashes = [{ :row_id=>"1", :url=>"stanleykaufman.com", :act_name=>"Stanley Chevrolet Kaufman\x99_\xCC", :street=>"825 E Fair St", :city=>"Kaufman", :state=>"TX", :zip=>"75142", :phone=>"(888) 457-4391\r\n" }]

  # sanitized_data = Utf8Sanitizer.sanitize(file_path: './lib/utf8_sanitizer/csv/seed.csv')
  # sanitized_data = Utf8Sanitizer.sanitize(data: orig_hashes)
  sanitized_data = Utf8Sanitizer.sanitize
  puts sanitized_data.inspect
  IRB.start
end
