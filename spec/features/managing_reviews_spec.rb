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

  context "Given I am a user on the homepage who can use the review submission form" do
    context "When I try to submit a review" do
      specify "I cannot submit a review with no content" do
        visit "/"
        fill_in "review_name", with: "Test User"
        click_on "Submit Review"
        expect(page).to(have_content("Content can't be blank"))
      end

      specify "I cannot submit a review with no name" do
        visit "/"
        fill_in "review_content", with: "Content for the review"
        click_on "Submit Review"
        expect(page).to(have_content("Name can't be blank"))
      end

      specify "I cannot submit a review with no name or content" do
        visit "/"
        click_on "Submit Review"
        expect(page).to(have_content("Name can't be blank"))
        expect(page).to(have_content("Content can't be blank"))
      end

      specify "I can submit a review and not see it yet (as it is hidden until an admin unhides it)" do
        visit "/"
        fill_in "review_name", with: "Test User"
        fill_in "review_content", with: "Content for the review"
        click_on "Submit Review"
        within(:css, ".reviews-carousel") do
          expect(page).not_to(have_content("Content for the review"))
        end
      end

      specify "I can submit a review and only the admin can see it through the review management system" do
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
  end

  context "Given there is a single review already within the database" do
    context "When I try to like a review" do
      specify "I can add 1 to its like counter (engagement count) by clicking the like button" do
      end

      specify "I can add 1 and remove 1 from its like counter by clicking the like button twice" do
      end

      specify "I can add 1 to its like counter and see this change persist after refreshing the browser" do
      end
    end

    context "When I have already liked a review" do
      specify "I can remove 1 from its like counter (engagement count) by clicking the like button" do
      end

      specify "I can remove 1 and add 1 from its like counter by clicking the like button twice" do
      end

      specify "I can remove from its like counter and see this change persist after refreshing the browser" do
      end
    end
  end

  context "Given I am an admin user with access to the review management system (with 3 reviews in the system)" do
    context "When I edit a review's visibility" do
      specify "I can make a review visible and see it on the home page" do
      end

      specify "I can make a review hidden and no longer see it on the home page" do
      end
    end

    context "When I edit the order of the reviews" do
      specify "I can move a review closer to the front so that it appears before other reviews on the home page" do
      end

      specify "I can move a review closer to the end so that it appears after other reviews on the home page" do
      end

      specify "I cannot move the first review even closer to the front as there is no up arrow shown" do
      end

      specify "I cannot move the last review even closer to the end as there is no down arrow" do
      end

      specify "I cannot edit the order of a hidden review as there are no arrows present" do
      end

      specify "I can discard changes to order by not clicking the 'Save Changes' button" do
      end
    end
  end
end
