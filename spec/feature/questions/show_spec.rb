require 'rails_helper'

feature 'User can view the question and the answers to it', "
In order to give an answer to community or read answers from it
As an user
I'd like to be able to vew question and answers to it
" do
  given(:question) { create(:question) }

  scenario 'User view question and answers to it' do
    question.answers.create!(body: 'Test answer')

    visit question_path(question)

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'Test answer'
  end
end
