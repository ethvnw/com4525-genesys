# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Managing questions") do
  let(:admin) { create(:admin) }

  feature "Submitting questions" do
    specify "I can add a question, and it wont immediately appear on the FAQ page" do
      visit faq_path
      fill_in "question_question", with: "Content for the question"
      click_on "Submit Question"
      expect(page).not_to(have_content("Content for the question"))
    end

    specify "I cannot add a question with no content" do
      visit faq_path
      expect(page).not_to(have_content("Question can't be blank"))
      click_on "Submit Question"
      expect(page).to(have_content("Question can't be blank"))
    end

    scenario "I cannot submit a question too much content (>100 characters)" do
      visit faq_path
      fill_in "question_question", with: "a" * 101
      click_on "Submit Question"
      expect(page).to(have_content("Question is too long (maximum is 100 characters)"))
    end
  end

  feature "tracking question engagement" do
    let!(:question) { create(:question) }
    scenario "Clicking on a question will increase its engagement count", js: true do
      visit faq_path

      expect(Question.find(question.id).engagement_counter).to(be_zero)
      click_button(id: "question_#{question.id}")
      sleep_for_js
      expect(Question.find(question.id).engagement_counter).to(eq(1))
    end

    scenario "Clicking a question more than once in one session only increases its engagement counter by 1", js: true do
      visit faq_path

      expect(Question.find(question.id).engagement_counter).to(be_zero)
      click_button(id: "question_#{question.id}")
      click_button(id: "question_#{question.id}")
      click_button(id: "question_#{question.id}")
      sleep_for_js
      expect(Question.find(question.id).engagement_counter).to(eq(1))
    end
  end

  feature "Managing questions dashboard" do
    specify "I can add a question, and it will appear as hidden on the questions dashboard" do
      visit faq_path
      fill_in "question_question", with: "Content for the hidden question"
      click_on "Submit Question"
      login_as(admin, scope: :user)
      visit manage_admin_questions_path
      expect(page).to(have_css("#hidden-items"))
      within("#hidden-items") do
        expect(page).to(have_content("Content for the hidden question"))
      end
    end

    specify "Hidden/visible questions will appear on the correct half of the dashboard" do
      create(:hidden_question)
      create(:question)

      login_as(admin, scope: :user)
      visit manage_admin_questions_path

      expect(page).to(have_css("#hidden-items"))
      expect(page).to(have_css("#visible-items"))
      within("#hidden-items") do
        expect(page).to(have_content("Mock hidden question"))
        expect(page).not_to(have_content("Mock question"))
      end
      within("#visible-items") do
        expect(page).to(have_content("Mock question"))
        expect(page).not_to(have_content("Mock hidden question"))
      end
    end
  end

  feature "Question Visibility" do
    specify "I can set a hidden question to visible" do
      question = create(:hidden_question)

      login_as(admin, scope: :user)
      visit manage_admin_questions_path

      click_on "visibility-toggle-#{question.id}"

      expect(Question.find(question.id).is_hidden).to(be(false))
      within("#visible-items") do
        expect(page).to(have_content("Mock hidden question"))
      end
    end

    specify "I can set a visible question to hidden" do
      question = create(:question)

      login_as(admin, scope: :user)
      visit manage_admin_questions_path

      click_on "visibility-toggle-#{question.id}"
      expect(Question.find(question.id).is_hidden).to(be(true))
      within("#hidden-items") do
        expect(page).to(have_content("Mock question"))
      end
    end

    specify "A visible question will appear on the FAQ page" do
      create(:question)
      visit faq_path
      expect(page).to(have_content("Mock question"))
    end

    specify "A hidden question will not appear on the FAQ page" do
      create(:hidden_question)
      visit faq_path
      expect(page).not_to(have_content("Mock hidden question"))
    end
  end

  feature "Answering questions" do
    specify "I can answer a question and it will show on the admin FAQ dashboard", js: true do
      question = create(:question)
      login_as(admin, scope: :user)
      visit manage_admin_questions_path
      within("#visible-items") do
        click_on "Answer"
      end

      fill_in "answer_#{question.id}", with: "An answer"
      click_on "Submit Answer"
      within("#item_#{question.id}") do
        expect(page).to(have_content("An answer"))
      end
    end

    specify "I can answer a question and it will show on the FAQ page", js: true do
      question = create(:question)
      login_as(admin, scope: :user)
      visit manage_admin_questions_path
      within("#visible-items") do
        click_on "Answer"
      end
      fill_in "answer_#{question.id}", with: "An answer"
      click_on "Submit Answer"
      sleep_for_js
      visit faq_path
      click_on "Mock question" # expand question
      expect(page).to(have_content("An answer"))
    end

    specify "If a question is answered, the answer will be prefilled in the form" do
      question = create(:question, :with_answer)
      login_as(admin, scope: :user)
      visit manage_admin_questions_path

      within("#answer-form-#{question.id}") do
        expect(page).to(have_content(question.answer))
      end
    end
  end

  feature "Editing question orders" do
    before do
      login_as(admin, scope: :user)
    end

    given!(:question1) { FactoryBot.create(:question, order: 1) }
    given!(:question2) { FactoryBot.create(:question, question: "OtherQuestion", order: 2) }
    given!(:hidden_question) { FactoryBot.create(:hidden_question) }

    scenario "I can move a question closer to the front so it appears before other questions on the faq page" do
      visit manage_admin_questions_path
      within(:css, "#visible-items #item_#{question2.id} .order-arrows") do
        find(".order-up-arrow").click
      end

      visit faq_path
      within(:css, "#faq-container") do
        first_question = find("#accordion-0")
        expect(first_question).to(have_content(question2.question))
      end
    end

    scenario "I can move a question closer to the end so it appears after other questions on the faq page" do
      visit manage_admin_questions_path
      within(:css, "#visible-items #item_#{question1.id} .order-arrows") do
        find(".order-down-arrow").click
      end

      visit faq_path
      within(:css, "#faq-container") do
        second_question = find("#accordion-1")
        expect(second_question).to(have_content(question1.question))
      end
    end

    scenario "I cannot move the first question even closer to the front as there is no up arrow shown" do
      visit manage_admin_questions_path
      within(:css, "#visible-items #item_#{question1.id} .order-arrows") do
        expect(page).not_to(have_css(".order-up-arrow"))
      end
    end

    scenario "I cannot move the last question even closer to the end as there is no down arrow" do
      visit manage_admin_questions_path
      within(:css, "#visible-items #item_#{question2.id} .order-arrows") do
        expect(page).not_to(have_css(".order-down-arrow"))
      end
    end

    scenario "I cannot edit the order of a hidden question as there are no arrows present" do
      visit manage_admin_questions_path
      within(:css, "#hidden-items #item_#{hidden_question.id}") do
        expect(page).not_to(have_css(".order-arrows"))
      end
    end
  end
end
