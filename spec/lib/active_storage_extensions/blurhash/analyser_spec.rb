# frozen_string_literal: true

require "rails_helper"
require "blurhash"

##
# Use Vips to create a test image with a given width, heigh, and bands (channels)
#
# @param width [Integer] the width of the image in pixels
# @param height [Integer] the height of the image in pixels
# @param bands [Integer] the number of bands (channels)
def create_test_image(width, height, bands)
  temp_file = Tempfile.new(["test_image", ".png"])

  # Create an image with the specified number of bands
  image = Vips::Image.black(width, height, bands: bands)
  image.write_to_file(temp_file.path)

  # Return a mock object that responds to filename
  double("image", filename: temp_file.path, tempfile: temp_file)
end

##
# Shared examples for build_thumbnail_for
RSpec.shared_examples("image thumbnail with bands") do |bands|
  let(:image) { create_test_image(600, 340, bands) }

  before do
    described_instance.build_thumbnail_for(image)
    @thumbnail = described_instance.instance_variable_get(:@thumbnail)
  end

  after do
    image.tempfile.unlink
  end

  it "resizes the image to fit within a 200x200 square" do
    expect(@thumbnail.width).to(be <= 200)
    expect(@thumbnail.height).to(be <= 200)
  end

  it "forces the image to have 3 bands" do
    expect(@thumbnail.bands).to(eq(3))
  end
end

RSpec.describe(ActiveStorageExtensions::Blurhash::Analyser) do
  let(:described_instance) { described_class.new(nil) }

  describe "#build_thumbnail_for" do
    context "when creating a thumbnail from a 3-band image" do
      it_behaves_like("image thumbnail with bands", 3)
    end

    context "when creating a thumbnail from a 2-band image" do
      it_behaves_like("image thumbnail with bands", 2)
    end

    context "when creating a thumbnail from a 1-band image" do
      it_behaves_like("image thumbnail with bands", 1)
    end

    context "when creating a thumbnail from a 4-band image" do
      it_behaves_like("image thumbnail with bands", 4)
    end
  end

  describe "#blurhash" do
    let(:mock_thumbnail) { double }
    before do
      allow(Blurhash).to(receive(:encode).and_return("mock_blurhash"))

      allow(mock_thumbnail).to(receive(:width).and_return(200))
      allow(mock_thumbnail).to(receive(:height).and_return(200))
      allow(mock_thumbnail).to(receive(:to_a).and_return([0, 0, 0]))
      described_instance.instance_variable_set(:@thumbnail, mock_thumbnail)
    end

    it "returns a hash containing an image's blurhash" do
      expect(Blurhash).to(receive(:encode).with(200, 200, [0, 0, 0]))
      expect(described_instance.blurhash).to(eq({ blurhash: "mock_blurhash" }))
    end
  end
end
