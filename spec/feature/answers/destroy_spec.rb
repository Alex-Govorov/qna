require 'rails_helper'

feature "The author can delete his own answer, but cannot delete someone else's answer", "
  In order to delete my own answer
  As an authenticated user
  I'd like to be able to delete answer
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'Test answer'
    click_on 'Post your answer'
  end

  scenario 'Authenticated user deletes their own answer' do
    click_on 'Delete'

    expect(page).to have_content 'Answer successfully deleted.'
  end

  scenario "Authenticated user tried deletes someone else's answer" do
    click_on 'Logout'

    sign_in(user2)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Only own answer can be deleted.'
  end
end
