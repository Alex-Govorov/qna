require 'rails_helper'

feature 'User being on the question page can write an answer to the question', "
  In order to reply community questions
  As an authenticated user
  I'd like to be able to write answer
" do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer the question', js: true do
      fill_in 'Body', with: 'Test answer'
      click_on 'Post your answer'

      expect(page).to have_content 'Test answer'
    end

    scenario 'answer the question with attached file', js: true do
      fill_in 'Body', with: 'Test answer'

      attach_file 'File', Rails.root.join('spec/rails_helper.rb')
      click_on 'Post your answer'

      within('.answers') { expect(page).to have_link 'rails_helper.rb' }
    end

    scenario 'answer the question with attached files', js: true do
      fill_in 'Body', with: 'Test answer'

      attach_file 'File', [Rails.root.join('spec/rails_helper.rb'),
                           Rails.root.join('spec/spec_helper.rb')]
      click_on 'Post your answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'answer the question with errors', js: true do
      click_on 'Post your answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tried to post answer' do
    visit question_path(question)
    fill_in 'Body', with: 'Test answer'
    click_on 'Post your answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
