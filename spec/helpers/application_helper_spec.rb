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

    context "when badge count is greater than 0" do
      let(:badge_count) { 3 }

      it "renders the notification badges" do
        result = helper.navbar_link_to(name, icon, path, badge_count)

        # Check each of the HTML tags
        expect(result).to(have_selector("div.nav-badge", text: "3"))
        expect(result).to(have_selector("div.nav-badge-lg", text: "3"))
      end
    end

    context "when badge count is not provided" do
      it "does not render the notification badges" do
        result = helper.navbar_link_to(name, icon, path)

        # Check each of the HTML tags
        expect(result).not_to(have_selector("div.nav-badge"))
        expect(result).not_to(have_selector("div.nav-badge-lg"))
      end
    end
  end

  describe "#add_param_button" do
    let(:key) { :mock_param }
    let(:value) { "mock-value" }
    let(:icon) { "bi-pin-map" }

    let(:original_params) { {} }
    let(:merged_params) { {} }
    let(:output_path) { "/mockpath" }
    let(:mock_request) { double(query_parameters: original_params) }

    before do
      allow(helper).to(receive(:request)).and_return(mock_request)
      allow(helper).to(receive(:params)).and_return(original_params)
      allow(helper).to(receive(:url_for).and_return(output_path))
    end

    context "when the query parameter hash is empty" do
      let(:original_params) { {} }
      let(:merged_params) { { key => value } }
      let(:output_path) { "/mockpath?#{key}=#{value}" }

      it "generates a link with the correct parameters" do
        # Check that url_for is called with the correct merged query parameters
        expect(helper).to(receive(:url_for).with(merged_params))
        helper.add_param_button(key, value, icon)
      end

      it "creates a link without the active class" do
        result = helper.add_param_button(key, value, icon)

        # Check each of the HTML tags
        expect(result).to(have_selector("a.change-view-link[href='#{output_path}']"))
        expect(result).to(have_selector("i.bi-pin-map.bi"))
        expect(result).to(have_selector("span", text: "Mock-value"))
      end
    end

    context "when the query parameter hash is not empty" do
      let(:original_params) { { other_param: "other-value" } }
      let(:merged_params) { { other_param: "other-value", key => value } }
      let(:output_path) { "/mockpath?other_param=other-value&#{key}=#{value}" }

      it "adds the new query parameter to the current ones" do
        # Check that url_for is called with the correct merged query parameters
        expect(helper).to(receive(:url_for).with(merged_params))
        helper.add_param_button(key, value, icon)
      end

      it "creates a link without get_error_class_withthe active class" do
        result = helper.add_param_button(key, value, icon)

        # Check each of the HTML tags
        expect(result).to(have_selector("a.change-view-link[href='#{output_path}']"))
        expect(result).to(have_selector("i.bi-pin-map.bi"))
        expect(result).to(have_selector("span", text: "Mock-value"))
      end
    end

    context "when the new parameter is already present in the query parameters" do
      let(:original_params) { { other_param: "other-value", key => value } }
      let(:merged_params) { { other_param: "other-value", key => value } }
      let(:output_path) { "/mockpath?#{key}=#{value}" }

      it "does not re-add the parameter" do
        # Check that url_for is called with the correct merged query parameters
        expect(helper).to(receive(:url_for).with(merged_params))
        helper.add_param_button(key, value, icon)
      end

      it "creates a link with the active class" do
        result = helper.add_param_button(key, value, icon)

        # Check each of the HTML tags
        expect(result).to(have_selector("a.active.change-view-link[href='#{output_path}']"))
        expect(result).to(have_selector("i.bi-pin-map.bi"))
        expect(result).to(have_selector("span", text: "Mock-value"))
      end
    end
  end

  describe "#get_formatted_errors" do
    context "when errors is nil" do
      let(:errors) { nil }
      it "returns nil" do
        expect(helper.get_formatted_errors(errors, :mock_field)).to(be_nil)
      end
    end

    context "when errors is an empty hash" do
      let(:errors) { {} }
      it "returns nil" do
        expect(helper.get_formatted_errors(errors, :mock_field)).to(be_nil)
      end
    end

    context "when errors is not empty, but does not contain the desired key" do
      let(:errors) { { other_key: ["error!"] } }
      it "returns nil" do
        expect(helper.get_formatted_errors(errors, :mock_field)).to(be_nil)
      end
    end

    context "with one error for the given key" do
      let(:errors) { { other_key: ["error!"], mock_field: ["error1"] } }
      it "returns the correct error message" do
        expect(helper.get_formatted_errors(errors, :mock_field)).to(eq("error1"))
      end
    end

    context "with multiple errors for the given key" do
      let(:errors) { { other_key: ["error!"], mock_field: ["error1", "error2", "error3"] } }
      it "joins the error messages with newlines" do
        expect(helper.get_formatted_errors(errors, :mock_field)).to(eq("error1\nerror2\nerror3"))
      end
    end

    context "with an empty array for the given key" do
      let(:errors) { { other_key: ["error!"], mock_field: [] } }
      it "returns nil" do
        expect(helper.get_formatted_errors(errors, :mock_field)).to(be_nil)
      end
    end
  end

  describe "#get_error_class_with" do
    context "when errors is nil" do
      let(:errors) { nil }
      it "returns nil" do
        expect(helper.get_error_class_with(nil, :mock_field)).to(be_nil)
      end
    end

    context "when errors is not nil, but does not contain an error for the given key" do
      let(:errors) { { other_field: ["error!"] } }
      it "returns the valid class" do
        expect(helper.get_error_class_with(errors, :mock_field)).to(eq("is-valid"))
      end
    end

    context "when errors is not nil, and contains an error for the given key" do
      let(:errors) { { other_field: ["error!"], mock_field: ["error1"] } }
      it "returns the invalid class" do
        expect(helper.get_error_class_with(errors, :mock_field)).to(eq("is-invalid"))
      end
    end
  end

  describe "#form_error_message" do
    context "when no error message is present for the given field" do
      before do
        allow(helper).to(receive(:get_formatted_errors)).and_return(nil)
      end

      it "returns nil" do
        expect(helper.form_error_message({}, :mock_field)).to(be_nil)
      end
    end

    context "when an error message is present for the given field" do
      before do
        allow(helper).to(receive(:get_formatted_errors)).and_return("error1\nerror2")
      end

      it "renders a feedback div, with the errors contained in a <span>" do
        # Can just pass an empty hash here as the get_formatted_errors stub makes sure that the errors are present
        result = helper.form_error_message({}, :mock_field)

        expect(result).to(have_selector("div.invalid-feedback"))
        expect(result).to(have_selector("span", text: "error1\nerror2"))
      end
    end
  end

  describe "#convert_events_to_json" do
    context "when nothing is passed" do
      it "returns JSON for an empty array" do
        expect(helper.convert_events_to_json(nil)).to(eq("[]"))
      end
    end

    context "when an empty array is passed" do
      it "returns JSON for an empty array" do
        expect(helper.convert_events_to_json([])).to(eq("[]"))
      end
    end

    context "when a list of events is passed" do
      let(:trip) { create(:trip) }
      let(:plan) { create(:plan) }
      let(:plan_without_end_location) { create(:plan, :no_end_location) }

      it "produces valid JSON" do
        result = helper.convert_events_to_json([trip, plan, plan_without_end_location])
        expect { JSON.parse(result) }.not_to(raise_error)
      end

      it "contains a list of all events passed" do
        result = JSON.parse(helper.convert_events_to_json([trip, plan, plan_without_end_location]))
        expect(result.is_a?(Array)).to(be_truthy)
        expect(result.length).to(eq(3))
      end

      it "contains only the ID, title, and coordinates of trip events" do
        result = JSON.parse(helper.convert_events_to_json([trip, plan, plan_without_end_location]))
        expect(result[0]).to(eq({
          "id" => trip.id,
          "title" => trip.title,
          "coords" => [trip.location_latitude, trip.location_longitude],
        }))
      end

      it "contains only the ID, title, and start coordinates of plan events with no end location" do
        result = JSON.parse(helper.convert_events_to_json([trip, plan, plan_without_end_location]))
        expect(result[2]).to(eq({
          "id" => plan_without_end_location.id,
          "title" => plan_without_end_location.title,
          "coords" => [
            plan_without_end_location.start_location_latitude,
            plan_without_end_location.start_location_longitude,
          ],
        }))
      end

      it "contains the end coordinates of plan events with an end location" do
        result = JSON.parse(helper.convert_events_to_json([trip, plan, plan_without_end_location]))
        expect(result[1]).to(eq({
          "id" => plan.id,
          "title" => plan.title,
          "coords" => [plan.start_location_latitude, plan.start_location_longitude],
          "endCoords" => [plan.end_location_latitude, plan.end_location_longitude],
        }))
      end
    end
  end
end
