#require YOUR_PROVIDER_API
require 'ticketmaster'
%w{ fogbugz ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end
