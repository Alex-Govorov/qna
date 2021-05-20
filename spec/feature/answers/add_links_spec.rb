require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:link) { 'http://127.0.0.1:3000/questions/' }
  given(:link2) { 'http://127.0.0.1:3000/questions/13' }
  given(:bad_url) { 'htpp:/dfdf.com' }
  given(:gist_link) { 'https://gist.github.com/d2ec80cade529155ce6e7611a6aca22e' }

  scenario 'User adds Link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Test answer'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: link

    click_on 'Post your answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: link
    end
  end

  scenario 'User adds Link with invalid url when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Test answer'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: bad_url

    click_on 'Post your answer'

    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'User adds Links when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Test answer'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: link

    click_on 'Add Link'

    within all('.wrapper-div').last do
      fill_in 'Link name', with: 'Second link'
      fill_in 'Url', with: link2
    end

    click_on 'Post your answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: link
      expect(page).to have_link 'Second link', href: link2
    end
  end

  scenario 'User add Gist link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Test answer'

    fill_in 'Link name', with: 'Gist link'
    fill_in 'Url', with: gist_link

    click_on 'Post your answer'

    within '.answers' do
      expect(page).to have_content 'test-guru-question.txt'
      expect(page).to have_content 'Чем отличается DROP от TRUNCATE?'
    end
  end
end
