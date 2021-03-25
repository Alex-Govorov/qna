require 'rails_helper'

feature 'User can view the question and the answers to it', "
In order to give an answer to community or read answers from it
As an user
I'd like to be able to vew question and answers to it
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User view question and answers to it' do
    question.answers.create(body: 'Answer1', user: user)
    question.answers.create(body: 'Answer2', user: user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'Answer1'
    expect(page).to have_content 'Answer2'
  end
end
