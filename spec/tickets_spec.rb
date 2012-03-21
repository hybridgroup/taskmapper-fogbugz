require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TicketMaster::Provider::Fogbugz::Ticket do
  before(:each) do
    VCR.use_cassette('fogbugz') do 
      @ticketmaster = TicketMaster.new(:fogbugz, :email => 'rafael@hybridgroup.com', :password => '1234567', :uri => 'https://ticketrb.fogbugz.com')
    end
    VCR.use_cassette('fogbugz-projects') { @project = @ticketmaster.project(2) }
    @ticket_id = 1
    @klass = TicketMaster::Provider::Fogbugz::Ticket
    @comment_klass = TicketMaster::Provider::Fogbugz::Comment
  end

  it "should be able to load all tickets" do
    VCR.use_cassette('fogbugz-tickets') { @tickets = @project.tickets }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all tickets based on an array of ids" do
    VCR.use_cassette('fogbugz-tickets-by-ids') {  @tickets = @project.tickets([@ticket_id]) }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.id.should == @ticket_id
  end

  it "should be able to load all tickets based on attributes" do
    VCR.use_cassette('fogbugz-tickets-by-attributes') {  @tickets = @project.tickets(:id => @ticket_id) }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.id.should == @ticket_id
  end

  it "should be able to load a single ticket" do
    VCR.use_cassette('fogbugz-single-ticket') {  @ticket = @project.ticket(@ticket_id) }
    @ticket.should be_an_instance_of(@klass)
    @ticket.id.should == @ticket_id
  end

end
