# frozen_string_literal: true

require "rails_helper"

RSpec.describe(BlurhashHelper, type: :helper) do
  before do
    allow_any_instance_of(ActiveStorageExtensions::Blurhash::Analyser)
      .to(receive(:metadata).and_return({ blurhash: "mock_blurhash" }))
  end

  describe "#blurhash_image_tag" do
    context "when a URL which is not part of this application is passed" do
      let(:image) { "https://test.com/image.jpg" }

      it "falls back to a regular image tag" do
        tag = helper.blurhash_image_tag(image)
        expect(tag).to(eq(image_tag(image)))
      end
    end

    context "when a non-ActiveStorage asset is passed" do
      let(:image) { "/public/favicon.png" }

      it "falls back to a regular image tag" do
        tag = helper.blurhash_image_tag(image)
        expect(tag).to(eq(image_tag(image)))
      end
    end

    context "when an ActiveStorage attachment is passed but blurhash is not present in metadata" do
      let(:image) { create(:trip).image }

      it "falls back to a regular image tag" do
        tag = helper.blurhash_image_tag(image)
        expect(tag).to(eq(image_tag(image)))
      end
    end

    context "when an ActiveStorage attachment is passed and blurhash is present in metadata" do
      let(:image) { create(:trip).image }

      before do
        image.metadata["blurhash"] = "mock_blurhash"
      end

      context "When the image is passed as a URL" do
        it "renders an image with blurhash fallback" do
          tag = helper.blurhash_image_tag(url_for(image).to_s)
          expect(tag).to(have_selector("div[data-blurhash='mock_blurhash']"))
          expect(tag).to(include(image_tag(url_for(image))))
          expect(tag).to(have_selector("canvas"))
        end
      end

      context "When the image is passed as a blob" do
        it "renders an image with blurhash fallback" do
          tag = helper.blurhash_image_tag(image.blob)
          expect(tag).to(have_selector("div[data-blurhash='mock_blurhash']"))
          expect(tag).to(include(image_tag(image)))
          expect(tag).to(have_selector("canvas"))
        end
      end

      context "When the image is passed as an attachment" do
        it "renders an image with blurhash fallback" do
          tag = helper.blurhash_image_tag(image)
          expect(tag).to(have_selector("div[data-blurhash='mock_blurhash']"))
          expect(tag).to(include(image_tag(image)))
          expect(tag).to(have_selector("canvas"))
        end
      end
    end
  end
end
