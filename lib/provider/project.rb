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
        self[:ixProject].to_i
      end

      def name
        self[:sProject]
      end

      def description
        self[:sProject]
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

      def self.find_by_attributes(attributes = {})
        search_by_attribute(self.find_all, attributes)
      end

      def self.find_all
        TicketMaster::Provider::Fogbugz.api.command(:listProjects).each do |project| 
          project[1]['project'].map { |xpro| self.new xpro }
        end
      end
    end
  end
end


