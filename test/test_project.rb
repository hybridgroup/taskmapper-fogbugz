require 'helper'

describe ProjectSpec 
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

  should "be able to load tickets based on attributes" do 
    projects = @tm.projects(:id => 1)
    assert_equal true, projects.instance_of?(Array)
    assert_equal true, projects.first.instance_of?(@klass)
    assert_equal "Sample Project", projects.first.name
  end

  should "be able to load a single ticket based on id" do 
    project = @tm.project(1)
    assert_equal true, project.instance_of?(@klass)
    assert_equal 1, project.id
  end

end
