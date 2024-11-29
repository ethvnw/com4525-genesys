# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing reviews") do
  before do
    login_as FactoryBot.create(
      :user,
      email: "test@epigenesys.org.uk",
      password: "GenesysModule#1",
      user_role: "admin",
    )
  end

  feature "Submitting reviews" do
    scenario "I cannot submit a review with no content" do
      visit "/"
      fill_in "review_name", with: "Test User"
      click_on "Submit Review"
      expect(page).to(have_content("Content can't be blank"))
    end

    scenario "I cannot submit a review with no name" do
      visit "/"
      fill_in "review_content", with: "Content for the review"
      click_on "Submit Review"
      expect(page).to(have_content("Name can't be blank"))
    end

    scenario "I cannot submit a review with no name or content" do
      visit "/"
      click_on "Submit Review"
      expect(page).to(have_content("Name can't be blank"))
      expect(page).to(have_content("Content can't be blank"))
    end

    scenario "I can submit a review and not see it yet (as it is hidden until an admin unhides it)" do
      visit "/"
      fill_in "review_name", with: "Test User"
      fill_in "review_content", with: "Content for the review"
      click_on "Submit Review"
      within(:css, ".reviews-carousel") do
        expect(page).not_to(have_content("Content for the review"))
      end
    end
  end

  feature "Seeing a review in the admin review management system" do
    scenario "I can submit a review and only the admin can see it through the review management system" do
      visit "/"
      fill_in "review_name", with: "Test User"
      fill_in "review_content", with: "Content for the review"
      click_on "Submit Review"
      visit "/admin/manage_reviews"
      within(:css, "#hidden-reviews") do
        expect(page).to(have_content("Content for the review"))
      end
    end
  end

  feature "Liking reviews" do
    given!(:review) { FactoryBot.create(:review) }

    scenario "I can like a review" do
      visit "/"
      within("div.reviews-carousel") do
        find("button#review_#{review.id}").click
      end
      visit "/"
      within("div.reviews-carousel") do
        expect(page).to(have_content("1"))
      end
    end

    scenario "I can unlike a review" do
      review.increment!(:engagement_counter)
      visit "/"
      within("div.reviews-carousel") do
        find("button#review_#{review.id}").click
      end

      visit "/"
      within("div.reviews-carousel") do
        expect(page).to(have_content("0"))
      end
    end
  end

  feature "Edit review visibility" do
    scenario "I can make a review visible and see it on the home page" do
    end

    scenario "I can make a review hidden and no longer see it on the home page" do
    end
  end

  feature "Editing review orders" do
    scenario "I can move a review closer to the front so that it appears before other reviews on the home page" do
    end

    scenario "I can move a review closer to the end so that it appears after other reviews on the home page" do
    end

    scenario "I cannot move the first review even closer to the front as there is no up arrow shown" do
    end

    scenario "I cannot move the last review even closer to the end as there is no down arrow" do
    end

    scenario "I cannot edit the order of a hidden review as there are no arrows present" do
    end

    scenario "I can discard changes to order by not clicking the 'Save Changes' button" do
    end
  end
end
