require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Fogbugz::Ticket do
  before(:each) do
    VCR.use_cassette('fogbugz') do
      @taskmapper = TaskMapper.new(:fogbugz, :email => 'rafael@hybridgroup.com', :password => '1234567', :uri => 'https://ticketrb.fogbugz.com')
    end
    VCR.use_cassette('fogbugz-projects') { @project = @taskmapper.project(2) }
    @ticket_id = 1
    @klass = TaskMapper::Provider::Fogbugz::Ticket
    @comment_klass = TaskMapper::Provider::Fogbugz::Comment
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

  it "should be able to create a ticket" do
    ticket = nil

    VCR.use_cassette('create-ticket') do
      ticket = @project.ticket! :title => "Should be able to create ticket",
        :priority => 2,
        :assignee => 'taskmapper'
    end

    ticket.should be_an_instance_of(@klass)
    ticket.id.should_not be_nil
    ticket.project_id.should == @project.id
  end

  it "should be able to update a ticket" do
    ticket = nil
    VCR.use_cassette('fogbugz-single-ticket') {  ticket = @project.ticket @ticket_id }
    ticket.title = "updated"
    VCR.use_cassette('update-ticket') {  ticket.save.should == true }
    ticket.title.should == "updated"
  end

end
