module TaskMapper::Provider
  module Fogbugz
    class Ticket < TaskMapper::Provider::Base::Ticket
      # Public: Creates a new Ticket based on passed arguments
      #
      # args - hash of Ticket values
      #
      # Returns a new Ticket
      def initialize(*args)
        args = args.first if args.is_a?(Array)
        super args
      end

      def id
        self['ixBug'].to_i
      end

      def title
        self['sTitle']
      end

      def title=(val)
        self['sTitle'] = val
      end

      def description
        self['LatestTextSummary']
      end

      def project_id
        self['ixProject'].to_i
      end

      def resolution
        nil
      end

      def status
        self['sStatus']
      end

      def requestor
        nil
      end

      def priority
        self['sPriority']
      end

      def assignee
        self['sPersonAssignedTo']
      end

      def created_at
        nil
      end

      def project_id
        self["ixProject"]
      end

      def updated_at
        Time.parse(self['dtLastUpdated'])
      rescue
        self['dfLastUpdated']
      end

      def comments(*options)
        warn "Fogbugz API doesn't support comments"
        []
      end

      def comment(*options)
        warn "Fogbugz API doesn't support comments"
        nil
      end

      # Public: Updates a Ticket in FogBugz
      #
      # Returns boolean indicating whether or not the Ticket was persisted
      def save
        !update_case.has_key?("error")
      end

      class << self
        # Public: Finds a particular ticket by it's ID
        #
        # project_id - ID of the Project the Ticket belongs to
        # id - the Ticket ID to look for
        #
        # Returns the matching Ticket
        def find_by_id(project_id, id)
          find_by_attributes(project_id, :id => id).first
        end

        # Public: Creates a new Ticket based on passed attributes and persists
        # it to Fogbugz
        #
        # attrs - hash of Ticket attributes
        #
        # Returns a new Ticket
        def create(attrs)
          if attrs.has_key? :description
            warn "Fogbugz Case does not handle description"
          end

          options = translate attrs,
            :title => :sTitle,
            :priority => :ixPriority,
            :assignee => :ixPersonAssignedTo,
            :project_id => :ixProject

          new_case = api.command(:new, options)

          options.merge!(:ixBug => new_case["case"]["ixBug"])

          self.new options
        end

        # Public: Finds Tickets based on a hash of attributes
        #
        # project_id - ID of the project the tickets belong to
        # attributes - hash of Ticket attributes to use when searching
        #
        # Returns an array of matching Tickets
        def find_by_attributes(project_id, attributes = {})
          search_by_attribute(self.find_all(project_id), attributes)
        end

        # Public: Finds all Tickets belonging to a project
        #
        # project_id - ID of Project to fetch Tickets for
        #
        # Returns an array of Tickets
        def find_all(project_id)
          query = "project:=#{project_id}"
          cols = %w(dtLastUpdated ixBug sStatus sTitle sLatestTextSummary
                    ixProject sProject sPersonAssignedTo sPriority).join(',')
          api.command(:search, :q => query, :cols => cols).collect do |ticket|
            self.new ticket[1]["case"]
          end.flatten
        end

        # Public: Translates hash keys
        #
        # hash - hash to translate
        # mappings to translate
        #
        # Returns the updated hash
        #
        # Examples:
        #   hash = { :a => 'alpha', :b => 'bravo' }
        #   translate(hash,
        #     :alpha => :a,
        #     :bravo => :b
        #   )
        #   #=> {
        #     :a => 'alpha', :b => 'bravo', :alpha => 'alpha', :b => 'bravo'
        #   }
        #
        def translate(hash, mapping)
          Hash[hash.map { |k, v| [mapping[k] ||= k, v]}]
        end

        private
        # Private: Shortcut for accessing Fogbugz API instance
        #
        # Returns Fogbugz API wrapper object
        def api
          TaskMapper::Provider::Fogbugz.api
        end
      end

      private
      # Private: Shortcut for accessing Fogbugz API instance
      #
      # Returns Fogbugz API wrapper object
      def api
        TaskMapper::Provider::Fogbugz.api
      end

      # Private: Updates Fogbugz Case in Fogbugz
      #
      # Returns updated case
      def update_case
        api.command :edit, to_case_hash
      end

      # Private: Converts Ticket to Fogbugz Case for use when updating Case via
      # API
      #
      # Returns a hash
      def to_case_hash
        {
          :ixBug => id,
          :sTitle => title
        }
      end
    end
  end
end
