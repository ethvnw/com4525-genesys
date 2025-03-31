# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Sharing::WhatsAppSharer) do
  let(:feature) { build(:app_feature) }

  describe ".call" do
    it "Correctly formats the feature details as a whatsapp sharing link", vcr: true do
      whatsapp = Sharing::WhatsappSharer.call(feature)

      encoded_feature_name = ERB::Util.url_encode(feature.name.to_s)
      encoded_feature_desc = ERB::Util.url_encode(feature.description.to_s.downcase)

      expect(whatsapp).to(start_with("https://wa.me"))
      expect(whatsapp.include?(encoded_feature_name)).to(be_truthy)
      expect(whatsapp.include?(encoded_feature_desc)).to(be_truthy)
    end
  end
end
