require 'helper'

class TestTicketmasterFogbugz < Test::Unit::TestCase
  should "be able to instatiate a new instance" do 
    @fogbugz = TicketMaster.new(:fogbugz, :email => 'fog@email.com', :password => '12345', :uri => 'http://fogbugz.testing.com')
    assert_equal true, @fogbugz.instance_of?(TicketMaster)
  end
end
