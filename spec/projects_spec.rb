require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TicketMaster::Provider::Fogbugz::Project do
  before(:each) do
	  @ticketmaster = TicketMaster.new(:fogbugz, :email => 'rafael@hybridgroup.com', :password => '1234567', :uri => 'https://hybridgroup.fogbugz.com')
    @klass = TicketMaster::Provider::Fogbugz::Project
  end
  
  it "should be able to load all projects" do
    @ticketmaster.projects.should be_an_instance_of(Array)
    @ticketmaster.projects.first.should be_an_instance_of(@klass)
  end
  
  it "should be able to load projects from an array of ids" do
    pending
    @projects = @ticketmaster.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.slug.should == @project_id
  end
  
  it "should be able to load all projects from attributes" do
    pending
    @projects = @ticketmaster.projects(:slug => @project_id)
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.slug.should == @project_id
  end
  
  it "should be able to find a project" do
    pending
    @ticketmaster.project.should == @klass
    @ticketmaster.project.find(@project_id).should be_an_instance_of(@klass)
  end
  
  it "should be able to find a project by slug" do
    pending
    @ticketmaster.project(@project_id).should be_an_instance_of(@klass)
    @ticketmaster.project(@project_id).slug.should == @project_id
  end

end
