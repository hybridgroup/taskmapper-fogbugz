require 'helper'

class TestProject < Test::Unit::TestCase
  CREDENTIALS = {:email => 'rafael@hybridgroup.com', :password => '123456', :uri => 'https://clutchapp.fogbugz.com'}

  def setup
    @klass = TicketMaster::Provider::Fogbugz::Project
    @tm = TicketMaster.new(:fogbugz, CREDENTIALS)
  end
  
  should "be able to load all projects" do 
    projects = @tm.projects
    assert_equal true, projects.instance_of?(Array)
    assert_equal true, projects.first.instance_of?(@klass)
  end

  should "be able to load a group of projects based on array of id's" do 
    projects = @tm.projects([1,2])
    assert_equal true, projects.instance_of?(Array)
    assert_equal true, projects.first.instance_of?(@klass)
    assert_equal 2, projects.first.id
  end

end
