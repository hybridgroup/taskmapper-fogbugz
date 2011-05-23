require 'helper'

class TestProject < Test::Unit::TestCase
  
  setup do
    @tm = TicketMaster.new(:fogbugz, :email => 'email@test.com', :password => '12345', :uri => 'http://fogbugz.testing.com')
  end
  
  should "be able to load all projects" do 
  end
end
