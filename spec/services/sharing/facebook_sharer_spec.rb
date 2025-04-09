# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Sharing::FacebookSharer) do
  let(:feature) { build(:app_feature) }

  describe ".call" do
    it "Correctly formats the feature details as a facebook sharing link" do
      facebook = Sharing::FacebookSharer.call(feature)

      expect(facebook).to(start_with("https://www.facebook.com"))
      expect(facebook.include?(ROOT_URL)).to(be_truthy)
    end
  end
end
