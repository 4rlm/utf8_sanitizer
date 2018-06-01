
module Utf8Sanitizer
  class Run

    def initialize
      @crm_data = {}
    end


    def import(args={})
      @crm_data = { stats: nil, data: nil, file_path: nil, criteria: nil }
      @crm_data.merge!(args)
      keys = args.compact.keys

      unless (keys & [:data, :file_path]).any?
        @crm_data[:file_path] = Seed.new.grab_seed_file_path
        # @crm_data[:data] = Seed.new.grab_seed_hashes
        @crm_data[:pollute_seeds] = true
        unless keys.include?(:criteria)
          @crm_data[:criteria] = Seed.new.grab_seed_web_criteria
        end
      end

      utf_result = Utf8Sanitizer::UTF.new.validate_data(@crm_data)
      @crm_data.merge!(utf_result)
    end



  end
end
