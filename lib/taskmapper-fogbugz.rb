#require YOUR_PROVIDER_API
require 'fogbugz'

%w{ fogbugz ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end
