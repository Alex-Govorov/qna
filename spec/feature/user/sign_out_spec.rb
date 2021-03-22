require 'rails_helper'

feature 'User can sign out', "
  In order to secure my data
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }

  scenario 'Authenticated user tries to sign out' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end
