module TaskMapper::Provider
  module Fogbugz
    # The comment class for taskmapper-fogbugz
    #
    # Do any mapping between taskmapper and your system's comment model here
    # versions of the ticket.
    #
    class Comment < TaskMapper::Provider::Base::Comment
      #API = Fogbugz::Comment # The class to access the api's comments
      # declare needed overloaded methods here

    end
  end
end
