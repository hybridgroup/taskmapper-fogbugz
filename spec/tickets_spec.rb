require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TicketMaster::Provider::Fogbugz::Ticket do
  before(:each) do
    @ticketmaster = TicketMaster.new(:fogbugz, :email => 'rafael@hybridgroup.com', :password => '1234567', :uri => 'https://hybridgroup.fogbugz.com')
    @project = @ticketmaster.project(2)
    @ticket_id = 1
    @klass = TicketMaster::Provider::Fogbugz::Ticket
    @comment_klass = TicketMaster::Provider::Fogbugz::Comment
  end

  it "should be able to load all tickets" do
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end
  
  it "should be able to load all tickets based on an array of ids" do
    @tickets = @project.tickets([@ticket_id])
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.id.should == @ticket_id
  end
  
  it "should be able to load all tickets based on attributes" do
    @tickets = @project.tickets(:id => @ticket_id)
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.id.should == @ticket_id
  end
  
  it "should be able to load a single ticket" do
    @ticket = @project.ticket(@ticket_id)
    @ticket.should be_an_instance_of(@klass)
    @ticket.id.should == @ticket_id
  end
  
end
