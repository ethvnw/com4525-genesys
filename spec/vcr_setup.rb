# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = "spec/fixtures/vcr"
  c.hook_into(:webmock)
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
  c.allow_http_connections_when_no_cassette = true

  c.around_http_request do |request|
    if request.uri.include?("api.pwnedpasswords.com")
      VCR.use_cassette("pwned_passwords") { request.proceed }
    else
      request.proceed
    end
  end
end
