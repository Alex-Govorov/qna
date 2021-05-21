require 'rails_helper'

feature 'User can edit his answer', "
In order to correct mistakes
As an author of answer
I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:link) { { name: 'My link', url: 'http://127.0.0.1:3000/questions/' } }
  given(:link2) { { name: 'Second link', url: 'http://127.0.0.1:3000/questions/' } }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his answer with attached files and adds new files', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        attach_file 'File', [Rails.root.join('spec/rails_helper.rb'),
                             Rails.root.join('spec/spec_helper.rb')]
        click_on 'Save'
        assert all('.file-links')

        click_on 'Edit'
        attach_file 'File', Rails.root.join('.rubocop.yml')
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link '.rubocop.yml'
      end
    end

    scenario 'edits his answer and adds new links', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'

        click_on 'Add Link'

        fill_in 'Link name', with: link[:name]
        fill_in 'Url', with: link[:url]

        click_on 'Add Link'

        within all('.wrapper-div').last do
          fill_in 'Link name', with: link2[:name]
          fill_in 'Url', with: link2[:url]
        end

        click_on 'Save'

        expect(page).to have_link link[:name], href: link[:url]
        expect(page).to have_link link2[:name], href: link2[:url]
      end
    end

    scenario 'edit his answer with errors', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer", js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'
      end

      click_on 'Logout'

      sign_in(user2)
      visit question_path(question)

      expect(page).to have_content 'edited answer'
      expect(page).to have_no_content 'Edit'
    end
  end
end
