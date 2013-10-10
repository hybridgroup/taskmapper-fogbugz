module TaskMapper::Provider
  # This is the Fogbugz Provider for taskmapper
  module Fogbugz
    include TaskMapper::Provider::Base
    class << self
      attr_accessor :api
    end

    #TICKET_API = Fogbugz::Ticket # The class to access the api's tickets
    #PROJECT_API = Fogbugz::Project # The class to access the api's projects

    # This is for cases when you want to instantiate using TaskMapper::Provider::Fogbugz.new(auth)
    def self.new(auth = {})
      TaskMapper.new(:fogbugz, auth)
    end

    # Providers must define an authorize method. This is used to initialize and set authentication
    # parameters to access the API
    def authorize(auth = {})
      @authentication ||= TaskMapper::Authenticator.new(auth)
      auth = @authentication

      unless auth.email? && auth.password? && auth.uri?
        raise TaskMapper::Exception.new 'Please provide email, password and uri'
      end

      begin
        @fogbugz = ::Fogbugz::Interface.new(:email => auth.email,
          :uri => auth.uri, :password => auth.password)
        TaskMapper::Provider::Fogbugz.api = @fogbugz
        @fogbugz.authenticate
      rescue Exception => ex
        warn "There was a problem authenticaticating #{ex.message}"
      end
    end
    # declare needed overloaded methods here

    def projects(*options)
      Project.find(options)
    end

    def project(*options)
      id = options.empty? ? 0 : options.first.to_i
      Project.find_by_id(id)
    end

    def valid?
      begin
        @fogbugz.command(:search, :q => 'case')
        true
      rescue
        false
      end
    end

  end
end


