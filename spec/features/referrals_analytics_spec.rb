# frozen_string_literal: true

require "rails_helper"
require "active_support/testing/time_helpers"
require_relative "../concerns/pageable_shared_examples"

RSpec.feature("Referral Analytics") do
  let(:reporter) { create(:reporter) }
  before do
    login_as(reporter, scope: :user)
    # Wednesday, 10th January 2024 (Week 2)
    travel_to Time.zone.parse("2024-01-10")
  end

  feature "Tracking the number of referrals and users being created", js: true do
    context "When no users have been created" do
      before do
        visit analytics_referrals_path
      end

      scenario "Viewing analytics for today" do
        click_on "Day"
        expect(page).to(have_content("Users Referred\n0\nToday"))
        expect(page).to(have_content("Users Created\n0\nToday"))
      end

      scenario "Viewing analytics for this week" do
        click_on "Week"
        expect(page).to(have_content("Users Referred\n0\nThis Week"))
        expect(page).to(have_content("Users Created\n0\nThis Week"))
      end

      scenario "Viewing analytics for this month" do
        click_on "Month"
        expect(page).to(have_content("Users Referred\n0\nThis Month"))
        expect(page).to(have_content("Users Created\n0\nThis Month"))
      end

      scenario "Viewing analytics for all time" do
        click_on "All Time"
        expect(page).to(have_content("Users Referred\n0\nAll Time"))
        expect(page).to(have_content("Users Created\n0\nAll Time"))
      end
    end

    context "When users have been created" do
      before do
        create(:user, created_at: Time.zone.parse("2023-12-31"))
        create(:user, created_at: Time.zone.parse("2024-01-01"))
        create(:user, created_at: Time.zone.parse("2024-01-07"))
        create(:user, created_at: Time.zone.parse("2024-01-08"))
        create(:user, created_at: Time.zone.parse("2024-01-10"))

        create(:referral, sender_user: reporter, created_at: Time.zone.parse("2023-12-12"))
        create(:referral, sender_user: reporter, created_at: Time.zone.parse("2024-01-01"))
        create(:referral, sender_user: reporter, created_at: Time.zone.parse("2024-01-08"))
        create(:referral, sender_user: reporter, created_at: Time.zone.parse("2024-01-10"))

        visit analytics_referrals_path
      end
      scenario "Viewing analytics for today" do
        click_on "Day"
        expect(page).to(have_content("Users Referred\n1\nToday"))
        expect(page).to(have_content("Users Created\n1\nToday"))
      end

      scenario "Viewing analytics for this week" do
        click_on "Week"
        expect(page).to(have_content("Users Referred\n2\nThis Week"))
        expect(page).to(have_content("Users Created\n2\nThis Week"))
      end

      scenario "Viewing analytics for this month" do
        click_on "Month"
        expect(page).to(have_content("Users Referred\n3\nThis Month"))
        expect(page).to(have_content("Users Created\n4\nThis Month"))
      end

      scenario "Viewing analytics for all time" do
        click_on "All Time"
        expect(page).to(have_content("Users Referred\n4\nAll Time"))
        expect(page).to(have_content("Users Created\n5\nAll Time"))
      end
    end
  end

  feature "Tracking the number of referrals sent per user" do
    context "when more than 25 referrals have been sent" do
      before do
        50.times do
          create(:referral)
        end

        visit analytics_referrals_path
      end

      it_behaves_like("regular pager", 25, 50)
    end
  end
end
