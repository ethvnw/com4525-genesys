require 'rails_helper'

RSpec.feature 'Managing reviews' do
    specify 'I can add a review' do
        visit '/'
        click_on 'have your experience heard'
        fill_in 'Name', with: 'Test User'
        fill_in 'Content', with: 'Content for the review'
        click_on 'Create Review'
        expect(page).to have_content 'Content for the review' 
    end

    specify 'I cannot add a review with no content' do
        visit '/'
        click_on 'have your experience heard'
        fill_in 'Name', with: 'Test User'
        click_on 'Create Review'
        expect(page).to have_content 'Content can\'t be blank' 
    end

    specify 'I cannot add a review with no name' do
        visit '/'
        click_on 'have your experience heard'
        fill_in 'Content', with: 'Content for the review'
        click_on 'Create Review'
        expect(page).to have_content 'Name can\'t be blank' 
    end

    specify 'I cannot add a review with no name or content' do
        visit '/'
        click_on 'have your experience heard'
        click_on 'Create Review'
        expect(page).to have_content 'Name can\'t be blank' 
        expect(page).to have_content 'Content can\'t be blank'
    end
end