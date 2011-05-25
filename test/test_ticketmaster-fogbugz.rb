require 'helper'

class TestTicketmasterFogbugz < Test::Unit::TestCase
  context "checking for ticketmaster initialization" do 
    should "be able to instatiate a new instance" do 
      @fogbugz = TicketMaster.new(:fogbugz, :email => 'fog@email.com', :password => '12345', :uri => 'http://fogbugz.testing.com')
      assert_equal true, @fogbugz.instance_of?(TicketMaster)
      assert_equal true, @fogbugz.kind_of?(TicketMaster::Provider::Fogbugz)
    end

    should "throw an error message in case any require field is missing" do 
      lambda { TicketMaster.new(:fogbugz, :password => '12345', :uri => 'http://fogbugz.testing.com') }.should raise_error
    end
  end
end
