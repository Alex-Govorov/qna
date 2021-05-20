require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links" do
  given(:user) { create(:user) }
  given(:link) { 'http://127.0.0.1:3000/questions/' }
  given(:link2) { 'http://127.0.0.1:3000/questions/13' }
  given(:bad_url) { 'htpp:/dfdf.com' }
  given(:gist_link) { 'https://gist.github.com/d2ec80cade529155ce6e7611a6aca22e' }

  scenario 'User adds Link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: link

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: link
  end

  scenario 'User adds Link with invalid url when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: bad_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'User adds Links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: link

    click_on 'Add Link'

    within all('.wrapper-div').last do
      fill_in 'Link name', with: 'Second gist'
      fill_in 'Url', with: link2
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: link
    expect(page).to have_link 'Second gist', href: link2
  end

  scenario 'User adds Gist link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_link

    click_on 'Ask'

    expect(page).to have_content 'test-guru-question.txt'
    expect(page).to have_content 'Чем отличается DROP от TRUNCATE?'
  end
end
