require 'helper'

class TestProject < Test::Unit::TestCase
  CREDENTIALS = {:email => 'rafael@hybridgroup.com', :password => '123456', :uri => 'https://clutchapp.fogbugz.com'}

  def setup
    @klass = TicketMaster::Provider::Fogbugz::Project
    @tm = TicketMaster.new(:fogbugz, CREDENTIALS)
  end
  
  should "be able to load all projects" do 
    assert_equal true, @tm.projects.instance_of?(Array)
    assert_equal true, @tm.projects.first.instance_of?(@klass)
  end
end
