module LinkedIn
  module API
    module Companies
      def company(*selector, filter: nil, **opts)
        root = ENV['LinkedinV2'].to_s.casecmp('true').zero? ? 'organizations' : 'companies'

        selector.compact!
        selector = selector.first if selector.size == 1

        unless filter.blank?
          filter = Hash[ *filter.to_s.split('=') ] unless filter.respond_to? :keys
          opts[:params] = {} if opts[:params].blank?
          opts[:params].to_h.merge! filter
          selector = nil
        end

        if selector.respond_to? :each
          selector = "companies::(#{ selector.map(&:to_param).join(',') })"
          root = nil
        end

        execute root, opts.merge(selector: selector)
      end


      # to call this,
      # client.company_search 'nike', fields: company_api_fields
      # https://api.linkedin.com/v2/company-search?keywords=nike
      #
      # client.company_search 'nike', 'footwear', fields: company_api_fields
      # https://api.linkedin.com/v2/company-search?keywords=nike%20footwear
      #
      # client.company_search 'nike', 'footwear', 'kobe', 'yellow', filter: 'hq-only=true', fields: company_api_fields
      # https://api.linkedin.com/v2/company-search?keywords=nike%20footwear%20kobe%20yellow&hq-only=true

      def company_search(*keywords, filter: nil, **opts)
        root = ENV['LinkedinV2'].to_s.casecmp('true').zero? ? 'search' : 'company-search'
        opts[:params] = {} if opts[:params].blank?
        opts[:params].merge! keywords: keywords.compact.join(' ')

        unless filter.blank?
          filter.each do |filt|
            new_filt = Hash[*filt.to_s.split('=')] unless filter.respond_to? :keys
            opts[:params].merge! new_filt
          end
        end

        unless opts[:facets].blank?
          facets = Hash['facets', opts[:facets]]
          opts[:params].merge! facets
        end

        execute root, opts
      end
    end
  end
end
