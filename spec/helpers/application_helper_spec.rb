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

  describe "#navbar_link_to" do
    let(:name) { "Home" }
    let(:icon) { "bi-house" }
    let(:path) { "/home" }

    context "when the current page matches the provided path" do
      it "generates an active link with filled icon" do
        # Mock the function call to current_page?
        allow(helper).to(receive(:current_page?).with(path).and_return(true))

        # Get the result of the method
        result = helper.navbar_link_to(name, icon, path)

        # Check each of the HTML tags
        expect(result).to(have_selector("li.nav-item"))
        expect(result).to(have_selector("a.nav-link.active[href='/home']"))
        expect(result).to(have_selector("i.bi-house-fill.bi"))
        expect(result).to(have_selector("span", text: "Home"))
      end
    end

    context "when the current page does not match provided the path" do
      it "generates a non-active link with regular icon" do
        # Mock the function call to current_page?
        allow(helper).to(receive(:current_page?).with(path).and_return(false))

        # Get the result of the method
        result = helper.navbar_link_to(name, icon, path)

        # Check each of the HTML tags
        expect(result).to(have_selector("li.nav-item"))
        expect(result).to(have_selector("a.nav-link[href='/home']"))
        expect(result).to(have_selector("i.bi-house.bi"))
        expect(result).to(have_selector("span", text: "Home"))
      end
    end
  end
end
