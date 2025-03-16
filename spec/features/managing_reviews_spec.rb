# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing reviews") do
  feature "Submitting reviews" do
    scenario "I cannot submit a review with no content" do
      visit root_path
      fill_in "review_name", with: "Test User"
      click_on "Submit Review"
      expect(page).to(have_content("Content can't be blank"))
    end

    scenario "I cannot submit a review with too much content (>400 characters)" do
      visit root_path
      fill_in "review_name", with: "Test User"
      fill_in "review_content", with: "a" * 401
      click_on "Submit Review"
      expect(page).to(have_content("Content is too long (maximum is 400 characters)"))
    end

    scenario "I cannot submit a review with no name" do
      visit root_path
      fill_in "review_content", with: "Content for the review"
      click_on "Submit Review"
      expect(page).to(have_content("Name can't be blank"))
    end

    scenario "I cannot submit a review with too long of a name (>50 characters)" do
      visit root_path
      fill_in "review_name", with: "a" * 51
      fill_in "review_content", with: "Test Content"
      click_on "Submit Review"
      expect(page).to(have_content("Name is too long (maximum is 50 characters)"))
    end

    scenario "I cannot submit a review with no name or content" do
      visit root_path
      click_on "Submit Review"
      expect(page).to(have_content("Name can't be blank"))
      expect(page).to(have_content("Content can't be blank"))
    end

    scenario "I can submit a review and not see it yet (as it is hidden until an admin unhides it)" do
      visit root_path
      fill_in "review_name", with: "Test User"
      fill_in "review_content", with: "Content for the review"
      click_on "Submit Review"
      within(:css, ".reviews-carousel") do
        expect(page).not_to(have_content("Content for the review"))
      end
    end
  end

  feature "Liking reviews" do
    given!(:review) { FactoryBot.create(:review) }

    scenario "I can like a review" do
      visit root_path
      within("div.reviews-carousel") do
        find("button#review_#{review.id}").click
      end
      visit root_path
      within("div.reviews-carousel") do
        expect(page).to(have_content("1"))
      end
    end

    scenario "I can unlike a review" do
      review.increment!(:engagement_counter)
      visit root_path
      within("div.reviews-carousel") do
        find("button#review_#{review.id}").click
      end
      visit root_path
      within("div.reviews-carousel") do
        expect(page).to(have_content("0"))
      end
    end

    scenario "I can like and unlike a review", js: true do
      visit root_path
      within("div.reviews-carousel") do
        find("button#review_#{review.id}").click
        sleep_for_js
        find("button#review_#{review.id}").click
      end
      visit root_path
      within("div.reviews-carousel") do
        expect(page).to(have_content("0"))
      end
    end
  end

  let(:admin) { create(:admin) }

  feature "Seeing a review in the admin review management system" do
    scenario "I can submit a review and only the admin can see it through the review management system" do
      visit root_path
      fill_in "review_name", with: "Test User"
      fill_in "review_content", with: "Content for the review"
      click_on "Submit Review"
      login_as(admin, scope: :user)
      visit manage_admin_reviews_path
      within(:css, "#hidden-items") do
        expect(page).to(have_content("Content for the review"))
      end
    end
  end

  feature "Edit review visibility" do
    before do
      login_as(admin, scope: :user)
    end

    given!(:review) { create(:review) }

    scenario "I can make a review hidden and no longer see it on the home page" do
      visit manage_admin_reviews_path

      click_on "visibility-toggle-#{review.id}"

      visit root_path
      within("div.reviews-carousel") do
        expect(page).not_to(have_content(review.content))
      end
    end

    scenario "I can make a review visible and see it on the home page" do
      hidden_review = create(:hidden_review)
      visit manage_admin_reviews_path

      click_on "visibility-toggle-#{hidden_review.id}"

      visit root_path
      within("div.reviews-carousel") do
        expect(page).to(have_content(hidden_review.content))
      end
    end
  end

  feature "Editing review orders" do
    before do
      login_as(admin, scope: :user)
    end

    given!(:review1) { FactoryBot.create(:review, order: 1) }
    given!(:review2) { FactoryBot.create(:review, name: "OtherName", content: "OtherContent", order: 2) }
    given!(:hidden_review) { FactoryBot.create(:hidden_review) }

    scenario "I can move a review closer to the front so it appears before other reviews on the home page" do
      visit manage_admin_reviews_path
      within(:css, "#visible-items #item_#{review2.id} .order-arrows") do
        find(".order-up-arrow").click
      end

      visit root_path
      within(:css, ".swiper-slide:first-child") do
        expect(page).to(have_content(review2.content))
      end
    end

    scenario "I can move a review closer to the end so it appears after other reviews on the home page" do
      visit manage_admin_reviews_path
      within(:css, "#visible-items #item_#{review1.id} .order-arrows") do
        find(".order-down-arrow").click
      end

      visit root_path
      within(:css, ".swiper-slide:nth-child(2)") do
        expect(page).to(have_content(review1.content))
      end
    end

    scenario "I cannot move the first review even closer to the front as there is no up arrow shown" do
      visit manage_admin_reviews_path
      within(:css, "#visible-items #item_#{review1.id} .order-arrows") do
        expect(page).not_to(have_css(".order-up-arrow"))
      end
    end

    scenario "I cannot move the last review even closer to the end as there is no down arrow" do
      visit manage_admin_reviews_path
      within(:css, "#visible-items #item_#{review2.id} .order-arrows") do
        expect(page).not_to(have_css(".order-down-arrow"))
      end
    end

    scenario "I cannot edit the order of a hidden review as there are no arrows present" do
      visit manage_admin_reviews_path
      within(:css, "#hidden-items #item_#{hidden_review.id}") do
        expect(page).not_to(have_css(".order-arrows"))
      end
    end
  end
end
