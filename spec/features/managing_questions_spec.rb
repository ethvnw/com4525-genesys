# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing questions") do
  let(:admin) { create(:admin) }

  specify "I can add a question, and it wont immediately appear on the FAQ page" do
    visit "/faq/"
    fill_in "question_question", with: "Content for the question"
    click_on "Submit Question"
    expect(page).not_to(have_content("Content for the question"))
  end

  specify "I cannot add a question with no content" do
    visit "/faq/"
    expect(page).not_to(have_content("Question can't be blank"))
    click_on "Submit Question"
    expect(page).to(have_content("Question can't be blank"))
  end

  specify "I can add a question, and it will appear as hidden on the questions dashboard" do
    visit "/faq/"
    fill_in "question_question", with: "Content for the hidden question"
    click_on "Submit Question"
    login_as(admin, scope: :user)
    visit "/admin/manage_questions"
    expect(page).to(have_css("#hidden-items"))
    within("#hidden-items") do
      expect(page).to(have_content("Content for the hidden question"))
    end
  end

  specify "Hidden/visible questions will appear on the correct half of the dashboard" do
    hidden_question = create(:question, question: "A hidden question", is_hidden: true)
    visible_question = create(:question, question: "A visible question", is_hidden: false)
    login_as(admin, scope: :user)
    visit "/admin/manage_questions"
    expect(page).to(have_css("#hidden-items"))
    expect(page).to(have_css("#visible-items"))
    within("#hidden-items") do
      expect(page).to(have_content(hidden_question.question))
    end
    within("#visible-items") do
      expect(page).to(have_content(visible_question.question))
    end
  end

  specify "I can set a hidden question to visible" do
    question = create(:question, question: "A hidden question", is_hidden: true)
    login_as(admin, scope: :user)
    visit "/admin/manage_questions"
    within("#visible-items") do
      expect(page).not_to(have_content("A hidden question"))
    end
    within("#hidden-items") do
      expect(page).to(have_content("A hidden question"))
      find("#visibility-toggle-#{question.id}").click
    end
    # Capybara deals with the request weirdly, so the page is refereshed to reload the content
    visit "/admin/manage_questions"
    within("#hidden-items") do
      expect(page).not_to(have_content("A hidden question"))
    end
    within("#visible-items") do
      expect(page).to(have_content("A hidden question"))
    end
  end
end
