# frozen_string_literal: true

require "rspec"

RSpec.describe("LandingPageJourneyMiddleware") do
  let(:app) { ->(env) { [200, env, "OK"] } }
  let(:middleware) { described_class.new(app) }
  let(:env) { { REQUEST_METHOD: "POST" } }

  context "when condition" do
    it "succeeds" do
      pending "Not implemented"
    end
  end
end
