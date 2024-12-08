# Test Middleware
## Mock IP Address
Mocking a request's IP address (in order to test geolocation, e.g. for registrations) can be done by simply setting a value for `ENV['MOCK_IP_ADDR']` in your test.

```
specify "a test that requires a geocodable IP address" do
  ENV["TEST_IP_ADDR"] = "185.156.172.142" # IP address in Amsterdam
  ...
  ENV["TEST_IP_ADDR"] = nil # Reset IP address
end
```

This will go through the `TestIpMock` middleware, which will intercept the request, and update its `REMOTE_ADDR` attribute, which is read by the geocoder gem.