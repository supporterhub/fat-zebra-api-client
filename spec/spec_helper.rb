require 'rubygems'
require 'bundler/setup'
require 'pry'
require 'rspec'
require 'vcr'
require 'webmock/rspec'
require 'date'

require 'fat_zebra'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = false
  # config.debug_logger = $stdout

  config.register_request_matcher :uri_ignoring_trailing_id do |*requests|
    requests.map(&:uri).map { |uri|
      uri.sub /\b\d+-[A-Z]-[A-Z\d]+\b/, "REFERENCE-NUMBER"
    }.map { |uri|
      uri.sub /BATCH-v1-PURCHASE-TEST-\d{8}-[a-z\d]{32}\.csv\z/, 'GENERIC_FILE_NAME.csv'
    }.reduce(&:==) # or VCR.request_matchers.uri_without_param(:to, :from)
  end

  config.register_request_matcher :fuzzy_body do |*requests|
    requests.map(&:body).map { |body|
      body.gsub /\b\h{20}\h{12}?(-\d)?\b/, 'REFERENCE-NUMBER'
    }.map { |body|
      body.gsub /\b(19|20)\d\d(-?)(0[1-9]|1[012])\2((0[1-9]|[12]\d|3[01])([012]\d([0-5]\d){1,2})?)?\b/, '9999\299\299'
      #                  yyyyyyyyyy     mmmmmmmmmmmmm    dddddddddddddddddddd  hhhhhhh msmsmsmsmsmsm
    }.reduce &:==
  end

  config.default_cassette_options = {
    match_requests_on: [
      :method,
      :query,
      :fuzzy_body,
      :headers,
      :uri_ignoring_trailing_id
    ]
  }
end

RSpec.configure do |c|

  c.expect_with :rspec do |c|
    c.syntax = :expect
  end
  c.mock_with :rspec

  c.include_context 'payloads'

  c.before(:each) do |ex|
    if ex.metadata[:no_default_account]
      FatZebra.instance_variable_set :@configurations, nil
    else
      FatZebra.configure do |config|
        config.username  = 'TEST'
        config.token     = 'TEST'
        config.gateway   = :sandbox
        config.test_mode = true
      end
    end
  end

end
