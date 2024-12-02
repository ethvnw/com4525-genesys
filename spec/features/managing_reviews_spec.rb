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
      visit admin_manage_reviews_path
      within(:css, "#hidden-items") do
        expect(page).to(have_content("Content for the review"))
      end
    end
  end

  feature "Edit review visibility" do
    before do
      login_as(admin, scope: :user)
    end

    given!(:review) { FactoryBot.create(:review) }

    scenario "I can make a review hidden and no longer see it on the home page" do
      visit admin_manage_reviews_path
      within(:css, "#visible-items form.update-visibility") do
        find("button").click
      end
      visit root_path
      within("div.reviews-carousel") do
        expect(page).not_to(have_content(review.content))
      end
    end

    scenario "I can make a review visible and see it on the home page" do
      review.toggle!(:is_hidden)
      visit admin_manage_reviews_path
      within(:css, "#hidden-items form.update-visibility") do
        find("button").click
      end
      visit root_path
      within("div.reviews-carousel") do
        expect(page).to(have_content(review.content))
      end
    end
  end

  feature "Editing review orders" do
    before do
      login_as(admin, scope: :user)
    end

    given!(:review1) { FactoryBot.create(:review) }
    given!(:review2) { FactoryBot.create(:review, name: "OtherName", content: "OtherContent", order: 1) }
    given!(:review3) do
      FactoryBot.create(:review, name: "HiddenName", content: "HiddenContent", is_hidden: true, order: 2)
    end

    scenario "I can move a review closer to the front so it appears before other reviews on the home page", js: true do
      visit admin_manage_reviews_path
      within(:css, "#visible-items #item_#{review2.id} .order-arrows") do
        find(".order-up-arrow").click
      end
      click_on "Save Changes"
      visit root_path
      within(:css, ".reviews-carousel .swiper-wrapper") do
        first_review = find('[data-swiper-slide-index="0"]')
        expect(first_review).to(have_content(review2.content))
      end
    end

    scenario "I can move a review closer to the end so it appears after other reviews on the home page", js: true do
      visit admin_manage_reviews_path
      within(:css, "#visible-items #item_#{review1.id} .order-arrows") do
        find(".order-down-arrow").click
      end
      click_on "Save Changes"
      visit root_path
      within(:css, ".reviews-carousel .swiper-wrapper") do
        second_review = find('[data-swiper-slide-index="1"]')
        expect(second_review).to(have_content(review1.content))
      end
    end

    scenario "I cannot move the first review even closer to the front as there is no up arrow shown", js: true do
      visit admin_manage_reviews_path
      within(:css, "#visible-items #item_#{review1.id} .order-arrows") do
        expect(page).not_to(have_css(".order-up-arrow"))
      end
    end

    scenario "I cannot move the last review even closer to the end as there is no down arrow", js: true do
      visit admin_manage_reviews_path
      within(:css, "#visible-items #item_#{review2.id} .order-arrows") do
        expect(page).not_to(have_css(".order-down-arrow"))
      end
    end

    scenario "I cannot edit the order of a hidden review as there are no arrows present", js: true do
      visit admin_manage_reviews_path
      within(:css, "#hidden-items #item_#{review3.id}") do
        expect(page).not_to(have_css(".order-arrows"))
      end
    end

    scenario "I can discard changes to order by not clicking the 'Save Changes' button", js: true do
      visit admin_manage_reviews_path
      within(:css, "#visible-items #item_#{review2.id} .order-arrows") do
        find(".order-up-arrow").click
      end
      visit root_path
      within(:css, ".reviews-carousel .swiper-wrapper") do
        first_review = find('[data-swiper-slide-index="0"]')
        expect(first_review).to(have_content(review1.content))
      end
    end
  end
end
