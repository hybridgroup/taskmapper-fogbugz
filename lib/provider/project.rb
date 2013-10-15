module TaskMapper::Provider
  module Fogbugz
    class Project < TaskMapper::Provider::Base::Project
      # Public: Creates a new Project based on passed arguments
      #
      # args - hash of Project values
      #
      # Returns a new Project
      def initialize(*args)
        args = args.first if args.is_a?(Array)
        super args
      end

      def id
        ixProject.to_i
      end

      def name
        sProject
      end

      def description
        sProject
      end

      # Public: Copies tickets/comments from one Project onto another.
      #
      # project - Project whose tickets/comments should be copied onto self
      #
      # Returns the updated project
      def copy(project)
        project.tickets.each do |ticket|
          copy_ticket = self.ticket!(
            :title => ticket.title,
            :description => ticket.description
          )
          ticket.comments.each do |comment|
            copy_ticket.comment!(:body => comment.body)
            sleep 1
          end
        end
        self
      end

      def ticket(*options)
        if options.first.is_a? Fixnum
          Ticket.find_by_id(self.id, options.first)
        else
          raise "You can only search for a single ticket based on id"
        end
      end

      class << self
        # Public: Searches all Projects, selecting those matching the provided
        # hash of attributes
        #
        # attributes - Hash of attributes to use when searching Projects
        #
        # Returns an Array of matching Projects
        def find_by_attributes(attributes = {})
          search_by_attribute(find_all, attributes)
        end

        # Public: Finds a particular Project by it's ID
        #
        # id - ID of Project to find
        #
        # Returns the requested Project
        def find_by_id(id)
          find_by_attributes(:id => id).first
        end

        # Public: Finds all Projects accessible via the Fogbugz API
        #
        # Returns an Array containing all Projects
        def find_all
          api.command(:listProjects).collect do |project|
            project[1]['project'].map { |p| self.new p }
          end.flatten
        end

        private
        # Private: Shortcut for accessing Fogbugz API instance
        #
        # Returns Fogbugz API wrapper object
        def api
          TaskMapper::Provider::Fogbugz.api
        end
      end
    end
  end
end
