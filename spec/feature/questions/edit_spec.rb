require 'rails_helper'

feature 'User can edit his question', "
In order to correct mistakes
As an author of question
I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in user
      visit questions_path
    end

    scenario 'edits his question', js: true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Body', with: 'edited question body'
        fill_in 'Title', with: 'edited question title'
        click_on 'Save'

        expect(page).not_to have_content question.title
        expect(page).to have_content 'edited question title'
        expect(page).not_to have_selector 'textarea'
      end
      click_on 'View'
      expect(page).to have_content 'edited question body'
    end

    scenario 'edits his question with attached files and adds new files', js: true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Body', with: 'edited question body'
        fill_in 'Title', with: 'edited question title'
        attach_file 'File', [Rails.root.join('spec/rails_helper.rb'),
                             Rails.root.join('spec/spec_helper.rb')]
        click_on 'Save'
        click_on 'Edit'

        attach_file 'File', Rails.root.join('.rubocop.yml')
        click_on 'Save'
      end

      click_on 'View'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link '.rubocop.yml'
    end

    scenario 'edit his question with errors', js: true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's questions", js: true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: 'edited question title'
        click_on 'Save'
      end

      click_on 'Logout'

      sign_in(user2)
      visit questions_path

      expect(page).to have_content 'edited question title'
      expect(page).to have_no_content 'Edit'
    end
  end
end
