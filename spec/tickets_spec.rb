require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Fogbugz::Ticket do
  let(:tm) { create_instance }
  let(:project) { VCR.use_cassette('fogbugz-projects') { tm.project(2) } }
  let(:ticket_id) { 1 }
  let(:ticket_class) { TaskMapper::Provider::Fogbugz::Ticket }

  describe "#tickets" do
    vcr_options = { :cassette_name => 'fogbugz-tickets' }
    context "without arguments", :vcr => vcr_options do
      let(:tickets) { project.tickets }

      it "returns an array containing all tickets" do
        expect(tickets).to be_an Array
        expect(tickets.first).to be_a ticket_class
      end
    end

    vcr_options = { :cassette_name => 'fogbugz-tickets-by-ids' }
    context "with an array of ticket IDs", :vcr => vcr_options do
      let(:tickets) { project.tickets [ticket_id] }

      it "returns an array containing matching tickets" do
        expect(tickets).to be_an Array
        expect(tickets.first).to be_a ticket_class
        expect(tickets.first.id).to eq ticket_id
      end
    end

    vcr_options = { :cassette_name => 'fogbugz-tickets-by-attributes' }
    context "with a hash containing a project ID", :vcr => vcr_options do
      let(:tickets) { project.tickets :id => ticket_id }

      it "returns an array containing the requested ticket" do
        expect(tickets).to be_an Array
        expect(tickets.first).to be_a ticket_class
        expect(tickets.first.id).to eq ticket_id
      end
    end
  end

  describe "#ticket" do
    vcr_options = { :cassette_name => 'fogbugz-single-ticket' }
    context "with a ticket ID", :vcr => vcr_options do
      let(:ticket) { project.ticket ticket_id }

      it "returns the matching ticket" do
        expect(ticket).to be_a ticket_class
        expect(ticket.id).to eq ticket_id
      end
    end

    vcr_options = { :cassette_name => "fogbugz-single-ticket" }
    describe "#save", :vcr => vcr_options do
      let(:ticket) { project.ticket ticket_id }

      it "should update the ticket" do
        ticket.title = "updated"
        VCR.use_cassette('update-ticket') do
          expect(ticket.save).to be_true
        end
        expect(ticket.title).to eq "updated"
      end
    end
  end

  describe "#ticket!" do
    vcr_options = { :cassette_name => 'create-ticket' }
    context "with a title, assignee, and priority", :vcr => vcr_options do
      let(:ticket) do
        project.ticket!(
          :title => 'Should be able to create ticket',
          :assignee => 'taskmapper',
          :priority => 2
        )
      end

      it "creates a new ticket" do
        expect(ticket).to be_a ticket_class
        expect(ticket.project_id).to eq project.id
        expect(ticket.title).to eq "Should be able to create ticket"
      end
    end
  end
end
