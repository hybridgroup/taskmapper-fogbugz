require 'spec_helper'

describe TaskMapper::Provider::Fogbugz do
  let(:tm) { create_instance }

  describe "#new" do
    it "creates a new TaskMapper instance" do
      expect(tm).to be_a TaskMapper
    end

    it "can be explicitly called as a provider" do
      VCR.use_cassette('fogbugz') do
        tm = TaskMapper::Provider::Fogbugz.new(
          :email => email,
          :password => password,
          :uri => base_uri
        )
      end

      expect(tm).to be_a TaskMapper
    end
  end

  describe "#valid?" do
    context "with a correctly authenticated Fogbugz user" do
      before do
        expect_any_instance_of(
          Fogbugz::Interface
        ).to receive(:command).with(:search, :q => 'case').and_return(true)
      end

      it "returns true" do
        expect(tm.valid?).to be_true
      end
    end

    context "with an incorrectly set-up Fogbugz user" do
      it "returns false" do
        expect(tm.valid?).to be_false
      end
    end
  end
end
