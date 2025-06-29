# frozen_string_literal: true

require "vcr"

require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true, allow: [
  "https://googlechromelabs.github.io",
  "https://edgedl.me.gvt1.com",
  "https://chromedriver.storage.googleapis.com",
  "https://selenium-release.storage.googleapis.com",
  /172\.17\.0\.\d+/,
  /chrome:4444/,
  /api.mapbox.com/,
])

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = "spec/fixtures/vcr"
  c.hook_into(:webmock)
  c.configure_rspec_metadata!

  # Ignore query params when matching requests
  c.default_cassette_options = {
    match_requests_on: [:method, :host, :path],
  }

  c.ignore_request do |request|
    # Ignore requests for gitlab CI containers
    URI(request.uri).host&.match?(/172\.17\.0\.\d+/) \
      || URI(request.uri).host == "chrome" \
      || URI(request.uri).host == "api.mapbox.com" # Also ignore mapbox, cassettes for this don't want to work
  end

  c.around_http_request do |request|
    if request.uri.include?("api.pwnedpasswords.com")
      VCR.use_cassette("pwned_passwords") { request.proceed }
    elsif request.uri.include?("ipinfo.io")
      VCR.use_cassette("ip_info") { request.proceed }
    elsif request.uri.include?("unsplash.com")
      VCR.use_cassette("unsplash") { request.proceed }
    elsif request.uri.include?("api.dicebear.com")
      VCR.use_cassette("dicebear") { request.proceed }
    else
      request.proceed
    end
  end
end
