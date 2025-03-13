# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = "vcr_cassettes"
  c.hook_into(:webmock)
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
  c.allow_http_connections_when_no_cassette = true
end
