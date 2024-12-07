# frozen_string_literal: true

# Middleware to mock IP request in tests - used for testing geolocation tracking
class TestIpMock
  def initialize(app)
    @app = app
  end

  def call(env)
    env["REMOTE_ADDR"] = ENV["TEST_IP_ADDR"] || "127.0.0.1"

    # Pass request along middleware stack
    @app.call(env)
  end
end
