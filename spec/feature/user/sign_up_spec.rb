require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions or post answers
  As an unauthenticated user
  I'd like to be able to sign up
" do
  scenario 'Unathenticated user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test_user@mail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
