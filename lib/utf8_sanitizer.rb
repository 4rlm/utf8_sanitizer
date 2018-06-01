require "utf8_sanitizer/version"
require 'utf8_sanitizer/run'
require 'utf8_sanitizer/seed'
require 'utf8_sanitizer/tools'
require 'utf8_sanitizer/utf'

module Utf8Sanitizer

  def self.run_wrap
    puts "Sample the Wrap!"
    run = self::Run.new
    binding.pry
    result = run.import ## returns formatted urls.
    binding.pry
  end

end
