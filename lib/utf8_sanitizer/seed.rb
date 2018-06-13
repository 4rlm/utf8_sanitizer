require 'csv'

module Utf8Sanitizer
  class Seed
    def initialize(args={})
      # @pollute_seeds = args.fetch(:pollute_seeds, false)
      # @seed_hashes = args.fetch(:seed_hashes, false)
      # @seed_csv = args.fetch(:seed_csv, false)
    end

    def pollute_seeds(text)
      list = ['h∑', 'lÔ', "\x92", "\x98", "\x99", "\xC0", "\xC1", "\xC2", "\xCC", "\xDD", "\xE5", "\xF8"]
      index = text.length / 2
      var = "#{list.sample}_#{list.sample}"
      text.insert(index, var)
      text.insert(-1, "\r\n")
      text
    end

    def grab_seed_file_path
      # "./lib/utf8_sanitizer/csv/seeds_clean.csv"
      "./lib/utf8_sanitizer/csv/seeds_dirty.csv"
      # "./lib/utf8_sanitizer/csv/seeds_mega.csv"
      # "./lib/utf8_sanitizer/csv/seeds_mini.csv"
      # "./lib/utf8_sanitizer/csv/seeds_mini_10.csv"
      # './lib/utf8_sanitizer/csv/seeds_mini_2_bug.csv'
    end

    ### Sample Hashes for validate_data
    # Utf8Sanitizer::Seed.new.grab_seed_hashes
    def grab_seed_hashes
      [{ row_id: 1,
         url: 'stanleykaufman.com',
         act_name: 'Stanley Chevrolet Kaufman',
         street: '825 E Fair St',
         city: 'Kaufman',
         state: 'TX',
         zip: '75142',
         phone: '(888) 457-4391' },
       { row_id: 2,
         url: 'leepartyka',
         act_name: 'Lee Partyka Chevrolet Mazda Isuzu Truck',
         street: '200 Skiff St',
         city: 'Hamden',
         state: 'CT',
         zip: '6518',
         phone: '(203) 288-7761' },
       { row_id: 3,
         url: 'burienhonda.fake.not.net.com',
         act_name: 'Honda of Burien 15026 1st Avenue South, Burien, WA 98148',
         street: '15026 1st Avenue South',
         city: 'Burien',
         state: 'WA',
         zip: '98148',
         phone: '(206) 246-9700' },
       { row_id: 4,
         url: 'cortlandchryslerdodgejeep.com',
         act_name: 'Cortland Chrysler Dodge Jeep RAM',
         street: '3878 West Rd',
         city: 'Cortland',
         state: 'NY',
         zip: '13045',
         phone: '(877) 279-3113' },
       { row_id: 5,
         url: 'imperialmotors.net',
         act_name: 'Imperial Motors',
         street: '4839 Virginia Beach Blvd',
         city: 'Virginia Beach',
         state: 'VA',
         zip: '23462',
         phone: '(757) 490-3651' }]
    end

  end
end
