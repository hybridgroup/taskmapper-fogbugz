module TicketMaster::Provider
  module Fogbugz
    # Ticket class for ticketmaster-fogbugz
    #
    
    class Ticket < TicketMaster::Provider::Base::Ticket
      #API = Fogbugz::Ticket # The class to access the api's tickets
      # declare needed overloaded methods here
      
      def self.find(project_id, options)
        self.find_all(project_id)
      end

      def self.find_all(project_id)
        TicketMaster::Provider::Fogbugz.api.command("search(cols=ixProject:#{project_id})")
      end
    end
  end
end
