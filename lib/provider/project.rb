module TicketMaster::Provider
  module Fogbugz
    # Project class for ticketmaster-fogbugz
    #
    #
    class Project < TicketMaster::Provider::Base::Project
      #API = Fogbugz::Project # The class to access the api's projects
      # declare needed overloaded methods here

      def initialize(*object)
        if object.first
          object = object.first
          unless object.is_a? Hash
            @system_data = {:client => object}
            hash = {:id => object['ixProject'].to_i,
              :name => object['sProject'],
              :description => object['sProject'], 
              :created_at => nil, 
              :updated_at => nil}
          else
            hash = object
          end
          super(hash)
        end
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

      # copy from this.copy(that) copies that into this
      def copy(project)
        project.tickets.each do |ticket|
          copy_ticket = self.ticket!(:title => ticket.title, :description => ticket.description)
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
      
      def ticket!(*args)
        return ticket_with! args.first if !args.empty? && args.first.is_a?(Hash)
        
        ticket_with! :title => args[0], :description => args[1]
      end
      
      def ticket_with!(attributes_hash)
        provider_parent(self.class)::Ticket.create(attributes_hash.merge :project_id => id)
      end

      def self.find(*options)
        if options[0].first.is_a? Array
          options[0].first.collect { |project_id| self.find_by_id(project_id) }
        elsif options[0].first.is_a? Hash
          self.find_by_attributes(options[0].first)
        else
          self.find_all
        end
      end

      def self.find_by_attributes(attributes = {})
        search_by_attribute(self.find_all, attributes)
      end

      def self.find_by_id(id)
        self.find_all.select { |project| project.id == id }.first
      end

      def self.find_all
        projects = []
        TicketMaster::Provider::Fogbugz.api.command(:listProjects).each do |project|
          projects << project[1]['project'].map { |xpro| self.new xpro }
        end
        projects.flatten
      end
    end
  end
end
