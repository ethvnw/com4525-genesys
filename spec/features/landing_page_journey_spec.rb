# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Landing Page Journey") do
  let(:app_feature) { FactoryBot.create(:app_feature) }
  let(:subscription_tier) { FactoryBot.create(:subscription_tier) }
  let!(:review) { FactoryBot.create(:review, is_hidden: false) }
  let(:question) { FactoryBot.create(:question, is_hidden: false) }

  before do
    visit root_path
  end

  scenario "When I like a review, it will be added to my landing page journey" do
    click_on(id: "review_#{review.id}")
    visit new_subscription_path(s_id: subscription_tier.id)
    fill_in "registration_email", with: "test@example.com"
    click_on "Notify Me"

    expect
  end
end
