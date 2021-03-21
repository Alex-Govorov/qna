require 'rails_helper'

feature 'User being on the question page can write an answer to the question', "
  In order to reply community questions
  As an user
  I'd like to be able to write answer
" do
  given(:question) { create(:question) }

  background do
    visit question_path(question)
  end

  scenario 'User answer the question' do
    fill_in 'Body', with: 'Test answer'
    click_on 'Post your answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Test answer'
  end

  scenario 'User answer the question with errors' do
    click_on 'Post your answer'

    expect(page).to have_content "Body can't be blank"
  end
end
