# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Sharing::TwitterSharer") do
  let(:feature) { build(:app_feature) }

  it "Correctly formats the feature details as a twitter sharing link" do
    twitter = Sharing::TwitterSharer.call(feature)

    encoded_feature_name = ERB::Util.url_encode(feature.name.to_s)
    encoded_feature_desc = ERB::Util.url_encode(feature.description.to_s.downcase)

    expect(twitter).to(start_with("https://twitter.com"))
    expect(twitter.include?(encoded_feature_name)).to(be_truthy)
    expect(twitter.include?(encoded_feature_desc)).to(be_truthy)
  end
end
