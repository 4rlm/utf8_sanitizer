require "utf8_sanitizer/version"
require 'utf8_sanitizer/seed'
require 'utf8_sanitizer/utf'
require 'pry'

module Utf8Sanitizer

  ## Args must include :data or :file_path, else seeds will run by default.
  def self.sanitize(args={})
    keys = args.compact.keys
    input = { stats: nil, file_path: nil, data: nil }.merge(args)

    ## Grabs seeds if :data or :file_path empty.
    unless (keys & [:data, :file_path]).any?
      ## Toggle data[:file_path] & data[:data] to test csv parsing or data hashes.
      # input[:file_path] = Seed.new.grab_seed_file_path
      input[:data] = Seed.new.grab_seed_hashes

      ## For Testing: Pollute_seeds adds non-utf8 chars to each line.
      input[:pollute_seeds] = true
    end

    ## Sanitizes input hash, then merges results to original input hash, and returns as sanitized_data.
    sanitized_data = input.merge!(Utf8Sanitizer::UTF.new.validate_data(input))
    binding.pry
    sanitized_data
  end


end
