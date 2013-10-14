module TaskMapper::Provider
  module Fogbugz
    class Project < TaskMapper::Provider::Base::Project
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
      end

      def tickets(*options)
        Ticket.find(self.id, options)
      end

      def ticket(*options)
        if options.first.is_a? Fixnum
          Ticket.find_by_id(self.id, options.first)
        else
          raise "You can only search for a single ticket based on id"
        end
      end

      def ticket!(attributes_hash)
        Ticket.create(attributes_hash.merge :project_id => id)
      end

      class << self
        def find_by_attributes(attributes = {})
          search_by_attribute(find_all, attributes)
        end

        def find_by_id(id)
          find_by_attributes(:id => id).first
        end

        def find_all
          api.command(:listProjects).collect do |project|
            project[1]['project'].map { |p| self.new p }
          end.flatten
        end

        private
        def api
          TaskMapper::Provider::Fogbugz.api
        end
      end
    end
  end
end
