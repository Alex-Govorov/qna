require 'rails_helper'

feature "The author can delete attachment in his own question", "
  In order to delete attachment in my own question
  As an authenticated user
  I'd like to be able to delete attachment
" do
  given!(:question) { create(:question) }
  given(:user2) { create(:user) }

  background do
    sign_in(question.user)

    visit questions_path
    click_on 'Edit'

    within '.questions' do
      attach_file 'File', [Rails.root.join('spec/rails_helper.rb'),
                           Rails.root.join('spec/spec_helper.rb')]
      click_on 'Save'
    end
  end

  scenario 'Authenticated user deletes any attachment in they own question', js: true do
    visit question_path(question)

    within '.question-attachments' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    find("#attachment-#{question.files.first.id}").click_on 'Delete'

    within '.question-attachments' do
      expect(page).not_to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "Authenticated user tried deletes attachment in someone else's question", js: true do
    click_on 'Logout'
    sign_in(user2)
    visit question_path(question)

    within('.question-attachments') { expect(page).not_to have_link 'Delete' }
  end

  scenario "Unauthenticated user tried deletes attachment in someone else's question", js: true do
    click_on 'Logout'
    visit question_path(question)

    within('.question-attachments') { expect(page).not_to have_link 'Delete' }
  end
end
