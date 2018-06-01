require "utf8_sanitizer/version"
require 'utf8_sanitizer/run'
require 'utf8_sanitizer/seed'
require 'utf8_sanitizer/utf'
require 'pry'

module Utf8Sanitizer

  def self.run_wrap
    run = self::Run.new
    result = run.import ## returns formatted urls.
  end

end
