# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Streamable) do
  # Create a mock controller that includes the Streamable concern
  class MockController < ActionController::Base
    include Streamable
  end

  let(:controller) { MockController.new }
  let(:mock_format) { double }
  let(:redirect_path) { "/mock/redirect/path" }
  let(:success_message) { { type: "success", content: "Mock success message" } }
  let(:danger_message) { { type: "danger", content: "Mock error message" } }

  # Mock necessary controller methods and request format
  before do
    allow(mock_format).to(receive(:turbo_stream))
    allow(mock_format).to(receive(:html))
    allow(controller).to(receive(:respond_to).and_yield(mock_format))
    allow(controller).to(receive(:flash).and_return({}))
    allow(controller).to(receive(:render))
    allow(controller).to(receive(:redirect_to))
  end

  describe "#stream_response" do
    let(:stream_template) { "test_template" }

    context "with turbo_stream format" do
      before do
        allow(mock_format).to(receive(:turbo_stream).and_yield)
      end

      it "renders the turbo stream template" do
        expect(controller).to(receive(:render).with(
          "turbo_stream_templates/#{stream_template}",
          layout: "turbo_stream",
        ))
        controller.stream_response(stream_template, redirect_path, success_message)
      end

      it "sets the message instance variable" do
        controller.stream_response(stream_template, redirect_path, success_message)
        expect(controller.instance_variable_get(:@message)).to(eq(success_message))
      end
    end

    context "with html format" do
      before do
        allow(mock_format).to(receive(:html).and_yield)
      end

      it "creates a flash message and redirects" do
        expect(controller).to(receive(:create_flash_message).with(success_message))
        expect(controller).to(receive(:redirect_to).with(redirect_path))

        controller.stream_response(stream_template, redirect_path, success_message)
      end
    end
  end

  describe "#turbo_redirect_to" do
    it "sets the redirect path instance variable" do
      controller.turbo_redirect_to(redirect_path, success_message)
      expect(controller.instance_variable_get(:@redirect_path)).to(eq(redirect_path))
    end

    it "creates a flash message" do
      expect(controller).to(receive(:create_flash_message).with(success_message))
      controller.turbo_redirect_to(redirect_path, success_message)
    end

    it "calls stream_response with turbo_redirect template" do
      expect(controller).to(receive(:stream_response).with("turbo_redirect", redirect_path))
      controller.turbo_redirect_to(redirect_path, success_message)
    end
  end

  describe "#respond_with_toast" do
    context "with turbo_stream format" do
      before do
        allow(mock_format).to(receive(:turbo_stream).and_yield)
      end

      it "renders the turbo toast partial" do
        expect(controller).to(receive(:render).with(
          partial: "turbo_stream_templates/turbo_toast",
          locals: { notification_type: success_message[:type], message_content: success_message[:content] },
        ))
        controller.respond_with_toast(success_message, redirect_path)
      end
    end

    context "with html format" do
      before do
        allow(mock_format).to(receive(:html).and_yield)
      end

      it "creates a flash message and redirects" do
        expect(controller).to(receive(:create_flash_message).with(success_message))
        expect(controller).to(receive(:redirect_to).with(redirect_path))
        controller.respond_with_toast(success_message, redirect_path)
      end
    end
  end

  describe "#create_flash_message" do
    context "when message is present" do
      it "sets notice flash for non-danger messages" do
        controller.create_flash_message(success_message)
        expect(controller.flash[:notice]).to(eq(success_message[:content]))
      end

      it "sets alert flash for danger messages" do
        controller.create_flash_message(danger_message)
        expect(controller.flash[:alert]).to(eq(danger_message[:content]))
      end
    end

    context "when message is nil" do
      it "does not set any flash message" do
        controller.create_flash_message(nil)
        expect(controller.flash).to(be_empty)
      end
    end
  end
end
