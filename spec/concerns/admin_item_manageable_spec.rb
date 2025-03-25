# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AdminItemManageable) do
  # Create a mock controller that includes the AdminItemManageable concern
  class MockController < ActionController::Base
    include AdminItemManageable
  end

  let(:controller) { MockController.new }
  let(:fallback_path) { "/mock/fallback/path" }

  # Mock methods from Streamable
  before do
    allow(controller).to(receive(:stream_response))
    allow(controller).to(receive(:respond_with_toast))
  end

  describe "#admin_item_stream_success_response" do
    let(:visible_items) { "mock_visible_items" }
    let(:hidden_items) { "mock_hidden_items" }

    it "calls stream_response with the correct arguments" do
      expect(controller).to(receive(:stream_response).with(
        "admin/items/success",
        fallback_path,
      ))

      controller.admin_item_stream_success_response(visible_items, hidden_items, fallback_path)
    end

    it "sets the correct instance variables" do
      controller.admin_item_stream_success_response(visible_items, hidden_items, fallback_path)
      expect(controller.instance_variable_get(:@visible_items)).to(eq(visible_items))
      expect(controller.instance_variable_get(:@hidden_items)).to(eq(hidden_items))
    end
  end

  describe "#admin_item_stream_error_response" do
    let(:error_message) { "Mock error message" }

    it "responds with a toast containing the error message" do
      expect(controller).to(receive(:respond_with_toast).with(
        { content: error_message, type: "danger" },
        fallback_path,
      ))

      controller.admin_item_stream_error_response(error_message, fallback_path)
    end
  end
end
