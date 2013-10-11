require 'spec_helper'

describe TaskMapper::Provider::Fogbugz::Project do
  let(:tm) { create_instance }
  let(:project_class) { TaskMapper::Provider::Fogbugz::Project }
  let(:project_id) { 2 }

  describe "#projects" do
    vcr_options = { :cassette_name => "all-fogbugz-projects" }
    context "with no arguments", :vcr => vcr_options do
      let(:projects) { tm.projects }

      it "returns an array of all projects" do
        expect(projects).to be_an Array
        expect(projects.first).to be_a project_class
      end
    end

    vcr_options = { :cassette_name => "all-fogbugz-projects" }
    context "with an array of project IDs", :vcr => vcr_options do
      let(:projects) { tm.projects [project_id] }

      it "should return an array of matching projects" do
        expect(projects).to be_an Array
        expect(projects.length).to eq 1
        expect(projects.first).to be_a project_class
        expect(projects.first.id).to eq project_id
      end
    end

    vcr_options = { :cassette_name => "load-projects-attributes" }
    context "with a hash of attributes", :vcr => vcr_options do
      let(:projects) { tm.projects :id => project_id }

      it "returns an array of matching projects" do
        expect(projects).to be_an Array
        expect(projects.length).to eq 1
        expect(projects.first).to be_a project_class
        expect(projects.first.id).to eq project_id
      end
    end
  end

  describe "#project" do
    vcr_options = { :cassette_name => "load-project-by-id" }
    context "with a project ID", :vcr => vcr_options do
      let(:project) { tm.project project_id }

      it "returns the requested project" do
        expect(project).to be_a project_class
        expect(project.id).to eq project_id
      end
    end
  end
end
