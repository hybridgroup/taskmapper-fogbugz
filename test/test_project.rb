require 'helper'

class TestProject < Test::Unit::TestCase
  context "read behaviour for proejcts" do 
    should "be able to load all projects" do 
      @tm = TicketMaster.new(:fogbugz, :email => 'email@test.com', :password => '12345', :uri => 'http://fogbugz.testing.com')
    end
  end
end
