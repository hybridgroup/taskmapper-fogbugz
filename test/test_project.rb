require 'helper'

class TestProject < Test::Unit::TestCase

  def setup
    @klass = TicketMaster::Provider::Fogbugz::Project
    @tm = TicketMaster.new(:fogbugz, :email => 'email@test.com', :password => '12345', :uri => 'http://fogbugz.testing.com')
    project = {:id => 1}
    ::Fogbugz::Interface.expects(:command).with(:listProjects).returns([project])
  end
  
  should "be able to load all projects" do 
    @tm.projects.should be_an_instance_of(Array)
    @tm.projects.first.should be_an_instance_of(@klass)
  end
end
