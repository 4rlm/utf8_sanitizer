# frozen_string_literal: false

module Utf8Sanitizer
  class Tools
    def initialize(args={})
      @args = args
      @empty_args = args.blank?
      @global_hash = grab_global_hash
    end

    def grab_global_hash
      keys = %i[row_id act_name street city state zip full_addr phone url url_path street_f city_f state_f zip_f full_addr_f phone_f url_f web_neg web_pos address_status phone_status web_status utf_status]
      @global_hash = Hash[keys.map { |a| [a, nil] }]
    end

    def update_global_hash(local_keys)
      gkeys = @global_hash.keys
      lkeys = local_keys.uniq.sort
      # lkeys = lkeys.map(&:to_sym)
      # gkeys = gkeys.map(&:to_sym)
      add_to_global = lkeys - gkeys
      same_keys = lkeys && gkeys
      add_to_global += same_keys - gkeys
      add_to_global&.uniq!

      if add_to_global.any?
        add_to_global += gkeys
        row = add_to_global.map { |_| nil }
        @global_hash = row_to_hsh(global_keys, row)
      end
    end

    def row_to_hsh(headers, row)
      headers = headers.map(&:to_sym)
      hash = Hash[headers.zip(row)]
    end

    ## scrub_oa, is only called if client OA args were passed at initialization.
    ## Results listed in url_hash[:web_neg]/[:web_pos], and don't impact or hinder final formatted url.
    ## Simply adds more details about user's preferences and criteria for the url are.
    def scrub_oa(hash, target, oa_name, include_or_equal)
      return hash unless oa_name.present? && !@empty_args
      criteria = @args.fetch(oa_name.to_sym, [])

      return hash unless criteria.any?
      tars = target.is_a?(::String) ? target.split(', ') : target

      scrub_matches = tars.map do |tar|
        return hash unless criteria.present?
        if include_or_equal == 'include'
          criteria.select { |crit| crit if tar.include?(crit) }.join(', ')
        elsif include_or_equal == 'equal'
          criteria.select { |crit| crit if tar == crit }.join(', ')
        end
      end

      scrub_match = scrub_matches&.uniq&.sort&.join(', ')
      return hash unless scrub_match.present?
      if oa_name.include?('web_neg')
        hash[:web_neg] << "#{oa_name}: #{scrub_match}"
      else
        hash[:web_pos] << "#{oa_name}: #{scrub_match}"
      end
      hash
    end

    def letter_case_check(str)
      return unless str.present?
      flashes = str&.gsub(/[^ A-Za-z]/, '')&.strip&.split(' ')
      flash = flashes&.reject { |e| e.length < 3 }&.join(' ')

      return str unless flash.present?
      has_caps = flash.scan(/[A-Z]/).any?
      has_lows = flash.scan(/[a-z]/).any?

      return str unless !has_caps || !has_lows
      str = str.split(' ')&.each { |el| el.capitalize! if el.gsub(/[^ A-Za-z]/, '')&.strip&.length > 2 }&.join(' ')
    end

    ### Save for later. ###

    ### These two methods can set instance vars from args.
    # def set(name, value)
    #   var_name = "@#{name}"  # the '@' is required
    #   self.instance_variable_set(var_name, value)
    # end

    # def set_args(args, inst_vars)
    #   return unless args.any?
    #   args.symbolize_keys!
    #   keys_to_slice = (args.keys.uniq) & inst_vars
    #   args.slice!(*keys_to_slice)
    #   args
    # end

    # def compare_diff(hsh)
    #   res = []
    #   hsh.to_a.reduce do |el, nxt|
    #     res << nxt.first if el.last != nxt.last
    #     el = nxt
    #   end
    #   res.compact!
    # end

  end
end
