module TaskMapper::Provider
  # This is the Fogbugz Provider for taskmapper
  module Fogbugz
    include TaskMapper::Provider::Base

    class << self
      attr_accessor :api, :email, :password, :uri

      def new(auth = {})
        TaskMapper.new(:fogbugz, auth)
      end
    end

    def provider
      TaskMapper::Provider::Fogbugz
    end

    def configure(auth)
      @fogbugz = ::Fogbugz::Interface.new(
        :email => auth[:email],
        :password => auth[:password],
        :uri => auth[:uri]
      )

      provider.api = @fogbugz

      @fogbugz.authenticate
    rescue Exception => ex
      warn "There was a problem authenticating against Fogbugz:"
      warn ex.message
    end

    def authorize(auth = {})
      @authentication ||= TaskMapper::Authenticator.new(auth)
      auth = @authentication

      unless auth.email && auth.password && auth.uri
        message = "Please provide a Fogbugz URI, email, and password."
        raise TaskMapper::Exception.new message
      end

      provider.email = auth.email
      provider.password = auth.password
      provider.uri = auth.uri

      configure auth
    end

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
