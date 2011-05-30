module TicketMaster::Provider
  module Fogbugz
    # Project class for ticketmaster-fogbugz
    #
    #
    class Project < TicketMaster::Provider::Base::Project
      #API = Fogbugz::Project # The class to access the api's projects
      # declare needed overloaded methods here
      
      
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
        TicketMaster::Provider::Fogbugz.api.command(:listProjects).map do |project| 
          self.new project
        end
      end
    end
  end
end


