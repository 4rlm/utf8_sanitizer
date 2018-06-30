require 'utf8_sanitizer/version'
require 'utf8_sanitizer/utf'
# require 'pry'

module Utf8Sanitizer
  ## Args must include :data or :file_path, else seeds will run by default.
  def self.sanitize(args = {})
    input = { stats: nil, file_path: nil, data: nil }.merge(args)

    return input unless input.compact.any?
    sanitized_data = input.merge(Utf8Sanitizer::UTF.new.validate_data(input))
  end
end
