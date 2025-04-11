# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Sharing::EmailSharer) do
  let(:feature) { build(:app_feature) }

  describe ".call" do
    it "Correctly formats the feature details as a mailto link" do
      mailto = Sharing::EmailSharer.call(feature)

      encoded_feature_name = ERB::Util.url_encode(feature.name.to_s)
      encoded_feature_desc = ERB::Util.url_encode(feature.description.to_s.downcase)

      expect(mailto).to(start_with("mailto:"))
      expect(mailto.include?(encoded_feature_name)).to(be_truthy)
      expect(mailto.include?(encoded_feature_desc)).to(be_truthy)
    end
  end
end
