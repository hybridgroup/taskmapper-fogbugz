module TicketMaster::Provider
  # This is the Fogbugz Provider for ticketmaster
  module Fogbugz
    include TicketMaster::Provider::Base
    #TICKET_API = Fogbugz::Ticket # The class to access the api's tickets
    #PROJECT_API = Fogbugz::Project # The class to access the api's projects
    
    # This is for cases when you want to instantiate using TicketMaster::Provider::Fogbugz.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:fogbugz, auth)
    end
    
    # Providers must define an authorize method. This is used to initialize and set authentication
    # parameters to access the API
    def authorize(auth = {})
      @authentication ||= TicketMaster::Authenticator.new(auth)
      # Set authentication parameters for whatever you're using to access the API
    end
    
    # declare needed overloaded methods here
    
  end
end


