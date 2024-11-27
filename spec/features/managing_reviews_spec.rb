# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing reviews") do
  specify "I can add a review" do
    visit "/"
    fill_in "review_name", with: "Test User"
    fill_in "review_content", with: "Content for the review"
    click_on "Submit Review"
    expect(page).not_to(have_content("Content for the review"))
  end

  specify "I cannot add a review with no content" do
    visit "/"
    fill_in "review_name", with: "Test User"
    click_on "Submit Review"
    expect(page).to(have_content("Content can't be blank"))
  end

  specify "I cannot add a review with no name" do
    visit "/"
    fill_in "review_content", with: "Content for the review"
    click_on "Submit Review"
    expect(page).to(have_content("Name can't be blank"))
  end

  specify "I cannot add a review with no name or content" do
    visit "/"
    click_on "Submit Review"
    expect(page).to(have_content("Name can't be blank"))
    expect(page).to(have_content("Content can't be blank"))
  end
end
