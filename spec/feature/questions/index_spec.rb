require 'rails_helper'

feature 'User can view the list of questions', "
  In order to give an answer to community or read answers
  As an user
  I'd like to be able to view questions list
" do
  let(:user) { create(:user) }

  scenario 'User view questions list' do
    Question.create!(title: 'Title1', body: 'Body1', user: user)
    Question.create!(title: 'Title2', body: 'Body2', user: user)

    visit questions_path
    expect(page).to have_content 'Title1'
    expect(page).to have_content 'Title2'
  end
end
