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

  feature "Managing questions dashboard" do
    specify "I can add a question, and it will appear as hidden on the questions dashboard" do
      visit faq_path
      fill_in "question_question", with: "Content for the hidden question"
      click_on "Submit Question"
      login_as(admin, scope: :user)
      visit admin_manage_questions_path
      expect(page).to(have_css("#hidden-items"))
      within("#hidden-items") do
        expect(page).to(have_content("Content for the hidden question"))
      end
    end

    specify "Hidden/visible questions will appear on the correct half of the dashboard" do
      hidden_question = create(:question, question: "A hidden question", is_hidden: true)
      visible_question = create(:question, question: "A visible question", is_hidden: false)
      login_as(admin, scope: :user)
      visit admin_manage_questions_path
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
      visit admin_manage_questions_path
      within("#visible-items") do
        expect(page).not_to(have_content("A hidden question"))
      end
      within("#hidden-items") do
        expect(page).to(have_content("A hidden question"))
        find("#visibility-toggle-#{question.id}").click
      end
      # Capybara deals with the request weirdly, so the page is refereshed to reload the content
      visit admin_manage_questions_path
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
      visit admin_manage_questions_path
      within("#hidden-items") do
        expect(page).not_to(have_content("A visible question"))
      end
      within("#visible-items") do
        expect(page).to(have_content("A visible question"))
        find("#visibility-toggle-#{question.id}").click
      end
      # Capybara deals with the request weirdly, so the page is refereshed to reload the content
      visit admin_manage_questions_path
      within("#visible-items") do
        expect(page).not_to(have_content("A visible question"))
      end
      within("#hidden-items") do
        expect(page).to(have_content("A visible question"))
      end
    end

    specify "A visible question will appear on the FAQ page" do
      create(:question, question: "A visible question", is_hidden: false)
      visit faq_path
      expect(page).to(have_content("A visible question"))
    end

    specify "A hidden question will not appear on the FAQ page" do
      create(:question, question: "A hidden question", is_hidden: true)
      visit faq_path
      expect(page).not_to(have_content("A hidden question"))
    end
  end

  feature "Answering questions" do
    specify "I can answer a question and it will show on the admin FAQ dashboard" do
      question = create(:question, question: "A question")
      login_as(admin, scope: :user)
      visit admin_manage_questions_path
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
      visit admin_manage_questions_path
      # Click on the answer button to make the modal appear
      within("#visible-items") do
        click_on "Answer"
      end
      fill_in "answer_#{question.id}", with: "An answer"
      click_on "Submit Answer"
      visit faq_path
      expect(page).to(have_content("An answer"))
    end

    specify "If a question is answered, the answer will automatically be on the edit modal" do
      question = create(:question, question: "A question", answer: "An answer", is_hidden: false)
      login_as(admin, scope: :user)
      visit admin_manage_questions_path
      # Click on the answer button to make the modal appear
      within("#visible-items") do
        click_on "Answer"
      end
      within("#answerModal_" + question.id.to_s) do
        expect(page).to(have_content(question.answer))
      end
    end
  end

  feature "Editing question orders" do
    before do
      login_as(admin, scope: :user)
    end

    given!(:question1) { FactoryBot.create(:question) }
    given!(:question2) { FactoryBot.create(:question, question: "OtherQuestion", order: 1) }
    given!(:question3) do
      FactoryBot.create(:question, question: "HiddenQuestion", is_hidden: true, order: 2)
    end

    scenario "I can move a question closer to the front so it appears before other questions on the faq page",
      js: true do
      visit admin_manage_questions_path
      within(:css, "#visible-items #item_#{question2.id} .order-arrows") do
        find(".order-up-arrow").click
      end
      click_on "Save Changes"
      visit faq_path
      within(:css, "#faqContainer") do
        first_question = find("#accordion-0")
        expect(first_question).to(have_content(question2.question))
      end
    end

    # scenario "I can move a review closer to the end so it appears after other reviews on the home page", js: true do
    #   visit admin_manage_reviews_path
    #   within(:css, "#visible-items #item_#{review1.id} .order-arrows") do
    #     find(".order-down-arrow").click
    #   end
    #   click_on "Save Changes"
    #   visit root_path
    #   within(:css, ".reviews-carousel .swiper-wrapper") do
    #     second_review = find('[data-swiper-slide-index="1"]')
    #     expect(second_review).to(have_content(review1.content))
    #   end
    # end

    # scenario "I cannot move the first review even closer to the front as there is no up arrow shown", js: true do
    #   visit admin_manage_reviews_path
    #   within(:css, "#visible-items #item_#{review1.id} .order-arrows") do
    #     expect(page).not_to(have_css(".order-up-arrow"))
    #   end
    # end

    # scenario "I cannot move the last review even closer to the end as there is no down arrow", js: true do
    #   visit admin_manage_reviews_path
    #   within(:css, "#visible-items #item_#{review2.id} .order-arrows") do
    #     expect(page).not_to(have_css(".order-down-arrow"))
    #   end
    # end

    # scenario "I cannot edit the order of a hidden review as there are no arrows present", js: true do
    #   visit admin_manage_reviews_path
    #   within(:css, "#hidden-items #item_#{review3.id}") do
    #     expect(page).not_to(have_css(".order-arrows"))
    #   end
    # end

    # scenario "I can discard changes to order by not clicking the 'Save Changes' button", js: true do
    #   visit admin_manage_reviews_path
    #   within(:css, "#visible-items #item_#{review2.id} .order-arrows") do
    #     find(".order-up-arrow").click
    #   end
    #   visit root_path
    #   within(:css, ".reviews-carousel .swiper-wrapper") do
    #     first_review = find('[data-swiper-slide-index="0"]')
    #     expect(first_review).to(have_content(review1.content))
    #   end
    # end
  end
end
