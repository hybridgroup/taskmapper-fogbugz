require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TicketMaster::Provider::Fogbugz::Project do
  before(:each) do
	  VCR.use_cassette('fogbugz') do 
      @ticketmaster = TicketMaster.new(:fogbugz, :email => 'rafael@hybridgroup.com', :password => '1234567', :uri => 'https://hybridgroup.fogbugz.com')
    end
    @klass = TicketMaster::Provider::Fogbugz::Project
    @project_id = 2
  end
  
  it "should be able to load all projects" do
    VCR.use_cassette('all-fogbugz-projects') { @projects = @ticketmaster.projects }
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
  end
  
  it "should be able to load projects from an array of ids" do
    VCR.use_cassette('load-projects-by-ids') { @projects = @ticketmaster.projects([@project_id]) }
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == @project_id
  end
  
  it "should be able to load all projects from attributes" do
    VCR.use_cassette('load-projects-attributes') { @projects = @ticketmaster.projects(:id => @project_id) }
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == @project_id
  end
  
  it "should be able to find a project by id" do
    VCR.use_cassette('load-project-by-id') { @project = @ticketmaster.project(@project_id) }
    @project.should be_an_instance_of(@klass)
    @project.id.should == @project_id
  end

end
