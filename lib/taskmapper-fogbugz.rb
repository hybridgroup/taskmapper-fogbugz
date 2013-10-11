require 'taskmapper'
require 'fogbugz'

%w{ fogbugz ticket project comment version }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end
