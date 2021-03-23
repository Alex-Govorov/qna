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
    click_on 'Delete'

    expect(page).to have_content 'Question successfully deleted.'
  end

  scenario "Authenticated user tried deletes someone else's question" do
    sign_in(user)
    visit questions_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Only own question can be deleted.'
  end
end
