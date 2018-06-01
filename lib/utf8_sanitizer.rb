require "utf8_sanitizer/version"
# require 'utf8_sanitizer/run'
require 'utf8_sanitizer/seed'
require 'utf8_sanitizer/utf'
require 'pry'

module Utf8Sanitizer

  def self.run_wrap
    # run = self::Run.new
    data = import ## returns formatted urls.
    binding.pry
    data
  end

  def self.import(args={})
    binding.pry
    data = { stats: nil, data: nil, file_path: nil, criteria: nil }
    data.merge!(args)
    keys = args.compact.keys

    unless (keys & [:data, :file_path]).any?
      data[:file_path] = Seed.new.grab_seed_file_path
      # @data[:data] = Seed.new.grab_seed_hashes
      data[:pollute_seeds] = true
      unless keys.include?(:criteria)
        data[:criteria] = Seed.new.grab_seed_web_criteria
      end
    end

    utf_result = Utf8Sanitizer::UTF.new.validate_data(data)
    data.merge!(utf_result)
    binding.pry
    data
  end


end
