# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing questions") do
  let(:admin) { create(:admin) }

  feature "Submitting questions" do
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

    scenario "I cannot submit a question too much content (>100 characters)" do
      visit "/faq/"
      fill_in "question_question", with: "a" * 101
      click_on "Submit Question"
      expect(page).to(have_content("Question is too long (maximum is 100 characters)"))
    end
  end

  feature "Managing questions dashboard" do
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
  end

  feature "Question Visibility" do
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

    specify "I can set a visible question to hidden" do
      question = create(:question, question: "A visible question", is_hidden: false)
      login_as(admin, scope: :user)
      visit "/admin/manage_questions"
      within("#hidden-items") do
        expect(page).not_to(have_content("A visible question"))
      end
      within("#visible-items") do
        expect(page).to(have_content("A visible question"))
        find("#visibility-toggle-#{question.id}").click
      end
      # Capybara deals with the request weirdly, so the page is refereshed to reload the content
      visit "/admin/manage_questions"
      within("#visible-items") do
        expect(page).not_to(have_content("A visible question"))
      end
      within("#hidden-items") do
        expect(page).to(have_content("A visible question"))
      end
    end

    specify "A visible question will appear on the FAQ page" do
      create(:question, question: "A visible question", is_hidden: false)
      visit "/faq/"
      expect(page).to(have_content("A visible question"))
    end

    specify "A hidden question will not appear on the FAQ page" do
      create(:question, question: "A hidden question", is_hidden: true)
      visit "/faq/"
      expect(page).not_to(have_content("A hidden question"))
    end
  end

  feature "Answering questions" do
    specify "I can answer a question and it will show on the admin FAQ dashboard" do
      question = create(:question, question: "A question")
      login_as(admin, scope: :user)
      visit "/admin/manage_questions"
      # Click on the answer button to make the modal appear
      within("#visible-items") do
        click_on "Answer"
      end
      fill_in "answer_#{question.id}", with: "An answer"
      click_on "Submit Answer"
      within("#item_#{question.id}") do
        expect(page).to(have_content("An answer"))
      end
    end

    specify "I can answer a question and it will show on the FAQ page" do
      question = create(:question, question: "A question", is_hidden: false)
      login_as(admin, scope: :user)
      visit "/admin/manage_questions"
      # Click on the answer button to make the modal appear
      within("#visible-items") do
        click_on "Answer"
      end
      fill_in "answer_#{question.id}", with: "An answer"
      click_on "Submit Answer"
      visit "/faq/"
      expect(page).to(have_content("An answer"))
    end
  end
end
