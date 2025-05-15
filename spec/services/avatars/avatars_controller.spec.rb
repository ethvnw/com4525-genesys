# frozen_string_literal: true

require "rails_helper"

RSpec.describe("API::Avatars", type: :request) do
  it "returns SVG for a user with no avatar" do
    user = create(:user, :no_avatar)
    get api_avatar_path(user)
    expect(response).to(have_http_status(:ok))
    expect(response.content_type).to(include("svg"))
    expect(response.body).to(include("<svg"))
  end
end
