# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationHelper, type: :helper) do
  describe "#get_script_paths" do
    context "when a list of multiple script packs are passed" do
      let(:scripts) { ["pack1", "pack2"] }

      it "correctly formats them for loading with javascript_pack_tag" do
        script_paths = get_script_paths(scripts)
        expect(script_paths).to(eq(["scriptpacks/pack1", "scriptpacks/pack2"]))
      end
    end

    context "when a list of a single script pack is passed" do
      let(:scripts) { ["pack1"] }

      it "correctly formats it for loading with javascript_pack_tag" do
        script_paths = get_script_paths(scripts)
        expect(script_paths).to(eq(["scriptpacks/pack1"]))
      end
    end

    context "when nil is passed" do
      it "returns an empty list" do
        script_paths = get_script_paths(nil)
        expect(script_paths).to(be_empty)
      end
    end
  end

  describe "#get_style_paths" do
    context "when a list of multiple style packs are passed" do
      let(:styles) { ["pack1", "pack2"] }

      it "correctly formats them for loading with stylesheet_pack_tag" do
        style_paths = get_style_paths(styles)
        expect(style_paths).to(eq(["stylepacks/pack1", "stylepacks/pack2"]))
      end
    end

    context "when a list of a single style pack is passed" do
      let(:styles) { ["pack1"] }

      it "correctly formats it for loading with stylesheet_pack_tag" do
        style_paths = get_style_paths(styles)
        expect(style_paths).to(eq(["stylepacks/pack1"]))
      end
    end

    context "when nil is passed" do
      it "returns an empty list" do
        style_paths = get_style_paths(nil)
        expect(style_paths).to(be_empty)
      end
    end
  end

  # Helper method to format dates like JavaScript defualt
  def to_js_date(date)
    date.strftime("%-d/%-m/%Y %-H:%M") # `-d` and `-m` omit leading zeros
  end
end
