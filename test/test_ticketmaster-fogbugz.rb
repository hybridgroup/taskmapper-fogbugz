require 'helper'

class TestTicketmasterFogbugz < Test::Unit::TestCase
  context "checking for ticketmaster initialization" do 
    should "be able to instatiate a new instance" do 
      @fogbugz = TicketMaster.new(:fogbugz, :email => 'rafael@hybridgroup.com', :password => '12345', :uri => 'https://clutchapp.fogbugz.com')
      assert_equal true, @fogbugz.instance_of?(TicketMaster)
      assert_equal true, @fogbugz.kind_of?(TicketMaster::Provider::Fogbugz)
    end
  end
end
