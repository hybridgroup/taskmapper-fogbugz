require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Fogbugz::Project do
  let(:tm) { create_instance }
  let(:project_class) { TaskMapper::Provider::Fogbugz::Project }
  let(:project_id) { 2 }

  vcr_options = { :cassette_name => "all-fogbugz-projects" }
  it "should be able to load all projects", :vcr => vcr_options do
    projects = tm.projects
    projects.should be_an_instance_of(Array)
    projects.first.should be_an_instance_of(project_class)
  end

  vcr_options = { :cassette_name => "all-fogbugz-projects" }
  it "should be able to load projects from an array of ids", :vcr => vcr_options do
    projects = tm.projects([project_id])
    projects.should be_an_instance_of(Array)
    projects.first.should be_an_instance_of(project_class)
    projects.first.id.should == project_id
  end

  vcr_options = { :cassette_name => "load-projects-attributes" }
  it "should be able to load all projects from attributes", :vcr => vcr_options do
    projects = tm.projects(:id => project_id)
    projects.should be_an_instance_of(Array)
    projects.first.should be_an_instance_of(project_class)
    projects.first.id.should == project_id
  end

  vcr_options = { :cassette_name => "load-project-by-id" }
  it "should be able to find a project by id", :vcr => vcr_options do
    project = tm.project(project_id)
    project.should be_an_instance_of(project_class)
    project.id.should == project_id
  end
end
