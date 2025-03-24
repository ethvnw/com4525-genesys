# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Member access") do
  let!(:member) { create(:user, username: "christaub") }

  # Public-facing refers to landing, faq, and pricing pages
  feature "Member cannot access public-facing areas of site and is redirected to home" do
    before do
      login_as(member, scope: :user)
    end

    scenario "Accessing the landing page" do
      visit root_path

      expect(current_path).to(eq(home_path))
      expect(page).to(have_content("Home"))
    end

    scenario "Accessing the faq page" do
      visit faq_path

      expect(current_path).to(eq(home_path))
      expect(page).to(have_content("Home"))
    end

    scenario "Accessing the pricing page" do
      visit pricing_subscriptions_path

      expect(current_path).to(eq(home_path))
      expect(page).to(have_content("Home"))
    end
  end
end
