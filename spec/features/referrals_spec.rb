# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Referrals") do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  before do
    login_as(user)
    visit home_path
  end

  feature "Referral form visibility" do
    specify "A referral form will be visible on the homepage" do
      save_page
      expect(page).to(have_content("Enjoying Roamio? Invite a Friend!"))
      expect(page).to(have_button("Invite to Roamio"))
    end
  end

  feature "Submitting a referral using their email address" do
    specify "I can refer someone who does not have Roamio" do
      email = "example@example.com"
      fill_in("email", with: email)
      click_button("Invite to Roamio")

      within("#toast-list .text-bg-success") do
        expect(page).to(have_content("Referral email sent to #{email}."))
      end
    end

    specify "I cannot refer someone who is already on Roamio" do
      fill_in("email", with: user2.email)
      click_button("Invite to Roamio")
      expect(page).to(have_content("A user with that email already exists."))
    end

    specify "I cannot refer an empty email address" do
      fill_in("email", with: "")
      click_button("Invite to Roamio")
      expect(page).to(have_content("Email is invalid."))
    end
  end
end
