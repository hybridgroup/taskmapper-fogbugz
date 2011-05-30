module TicketMaster::Provider
  # This is the Fogbugz Provider for ticketmaster
  module Fogbugz
    include TicketMaster::Provider::Base
    class << self
      attr_accessor :api
    end

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
      auth = @authentication
      if auth.email.nil? || auth.password.nil? || auth.uri.nil?
        raise "Please provide email, password and uri"
      end
      @fogbugz = ::Fogbugz::Interface.new(auth).authenticate
      TicketMaster::Provider::Fogbugz.api = @fogbugz
    end
    
    # declare needed overloaded methods here
    
  end
end


