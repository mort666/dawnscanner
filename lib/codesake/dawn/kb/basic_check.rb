require 'cvss'

module Codesake
  module Dawn
    module Kb
      module BasicCheck

        attr_reader :name
        attr_reader :cvss
        attr_reader :cwe
        attr_reader :owasp
        attr_reader :release_date
        attr_reader :applies
        attr_reader :kind
        attr_reader :message
        attr_reader :remediation
        attr_reader :aux_links
        attr_reader :mitigated

        # The framework target version
        attr_reader   :target_version
        # The versions of the framework that fixes the vulnerability
        attr_reader   :fixes_version

        # Vulnerability evidences
        attr_reader   :evidences

        def initialize(options={})
          @name         = options[:name]
          @cvss         = options[:cvss]
          @cwe          = options[:cwe]
          @owasp        = options[:owasp]
          @release_date = options[:release_date]
          @applies      = []
          @applies      = options[:applies] unless options[:applies].nil?
          @kind         = options[:kind]
          @message      = options[:message]
          @remediation  = options[:mitigation]
          @aux_links    = options[:aux_links]

          @target_version = options[:target_version]
          @fixes_version  = options[:fixes_version]

          @evidences    = []
          @mitigated    = false
    
        end


        def applies_to?(name)
          ! @applies.find_index(name).nil?
        end
        def cve_link
          "http://cve.mitre.org/cgi-bin/cvename.cgi?name=#{@name}"
        end
        def nvd_link
          "http://web.nvd.nist.gov/view/vuln/detail?vulnId=#{@name}"
        end

        # @target_version = '2.3.11'
        # @fixes_version = ['2.3.18', '3.2.13', '3.1.12' ] 
        def is_vulnerable_version?(target = nil, fixes = nil)
          target  = @target_version if target.nil?
          fixes   = @fixes_version  if fixes.nil?
          return false if target.nil? or fixes.empty?

          ret = false

          target_v_array = target.split(".").map! { |n| n.to_i }
          fixes.each do |fv|
            fixes_v_array = fv.split(".").map! { |n| n.to_i }
            if target_v_array[0] == fixes_v_array[0]
              ret = true if target_v_array[1] < fixes_v_array[1] # same major but previous minor
              ret = true if target_v_array[1] == fixes_v_array[1] and target_v_array[2] < fixes_v_array[2] 
            end
          end

          ret
        end

        def cvss_score
          return Cvss::Engine.new.score(self.cvss) unless self.cvss.nil?
          "    "
        end

        def mitigated?
          self.mitigated
        end

      end
    end
  end
end
