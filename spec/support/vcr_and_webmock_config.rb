# frozen_string_literal: true

require "vcr"

require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true, allow: [
  "https://googlechromelabs.github.io",
  "https://edgedl.me.gvt1.com",
  "https://chromedriver.storage.googleapis.com",
  "https://selenium-release.storage.googleapis.com",
])

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = "spec/fixtures/vcr"
  c.hook_into(:webmock)
  c.configure_rspec_metadata!

  c.around_http_request do |request|
    if request.uri.include?("api.pwnedpasswords.com")
      VCR.use_cassette("pwned_passwords") { request.proceed }
    else
      request.proceed
    end
  end
end
