require 'rails_helper'

feature "The author can delete his own question, but cannot delete someone else's question", "
  In order to delete my own question
  As an authenticated user
  I'd like to be able to delete question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user deletes their own question' do
    sign_in(question.user)
    visit questions_path(question)

    expect(page).to have_content question.title

    click_on 'Delete'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to have_no_content question.title
  end

  scenario "Authenticated user tried deletes someone else's question" do
    sign_in(user)
    visit questions_path(question)

    expect(page).to have_content question.title
    expect(page).to have_no_content 'Delete'
  end

  scenario "Unauthenticated user tried deletes someone else's question" do
    visit questions_path(question)

    expect(page).to have_content question.title
    expect(page).to have_no_content 'Delete'
  end
end
