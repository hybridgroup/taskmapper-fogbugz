require 'taskmapper-fogbugz'
require 'rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :once }
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.color_enabled = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

def email
  'rafael@hybridgroup.com'
end

def password
  '1234567'
end

def base_uri
  'https://ticketrb.fogbugz.com'
end

def create_instance(e = email, p = password, uri = base_uri)
  VCR.use_cassette('fogbugz') do
    TaskMapper.new(:fogbugz, :email => e, :password => p, :uri => uri)
  end
end
