require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Fogbugz::Ticket do
  let(:tm) { create_instance }
  let(:project) { VCR.use_cassette('fogbugz-projects') { tm.project(2) } }
  let(:ticket_id) { 1 }
  let(:ticket_class) { TaskMapper::Provider::Fogbugz::Ticket }

  vcr_options = { :cassette_name => 'fogbugz-tickets' }
  it "should be able to load all tickets", :vcr => vcr_options do
    tickets = project.tickets
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(ticket_class)
  end

  vcr_options = { :cassette_name => 'fogbugz-tickets-by-ids' }
  it "should be able to load all tickets based on an array of ids", :vcr => vcr_options do
    tickets = project.tickets([ticket_id])
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(ticket_class)
    tickets.first.id.should == ticket_id
  end

  vcr_options = { :cassette_name => 'fogbugz-tickets-by-attributes' }
  it "should be able to load all tickets based on attributes", :vcr => vcr_options do
    tickets = project.tickets(:id => ticket_id)
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(ticket_class)
    tickets.first.id.should == ticket_id
  end

  vcr_options = { :cassette_name => 'fogbugz-single-ticket' }
  it "should be able to load a single ticket", :vcr => vcr_options do
    ticket = project.ticket(ticket_id)
    ticket.should be_an_instance_of(ticket_class)
    ticket.id.should == ticket_id
  end

  vcr_options = { :cassette_name => 'create-ticket' }
  it "should be able to create a ticket", :vcr => vcr_options do
    ticket = nil

    ticket = project.ticket! :title => "Should be able to create ticket",
      :priority => 2,
      :assignee => 'taskmapper'

    ticket.should be_an_instance_of(ticket_class)
    ticket.id.should_not be_nil
    ticket.project_id.should == project.id
  end

  vcr_options = { :cassette_name => "fogbugz-single-ticket" }
  it "should be able to update a ticket", :vcr => vcr_options do
    ticket = project.ticket ticket_id
    ticket.title = "updated"
    VCR.use_cassette('update-ticket') {  ticket.save.should == true }
    ticket.title.should == "updated"
  end
end
