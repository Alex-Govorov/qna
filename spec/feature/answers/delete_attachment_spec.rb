require 'rails_helper'

feature "The author can delete attachment in his own answer", "
  In order to delete attachment in my own answer
  As an authenticated user
  I'd like to be able to delete attachment
" do
  given!(:answer) { create(:answer) }
  given(:user2) { create(:user) }

  background do
    sign_in(answer.user)

    visit question_path(answer.question)
    click_on 'Edit'

    within '.answers' do
      attach_file 'File', [Rails.root.join('spec/rails_helper.rb'),
                           Rails.root.join('spec/spec_helper.rb')]
      click_on 'Save'

      assert all('.answer-attachments')
    end
  end

  scenario 'Authenticated user deletes any attachment in they own answer', js: true do
    visit question_path(answer.question)

    within '.answer-attachments' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    find("#attachment-#{answer.files.first.id}").click_on 'Delete'

    within '.answer-attachments' do
      expect(page).not_to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "Authenticated user tried deletes attachment in someone else's answer", js: true do
    click_on 'Logout'
    sign_in(user2)
    visit question_path(answer.question)

    within('.answer-attachments') { expect(page).not_to have_link 'Delete' }
  end

  scenario "Unauthenticated user tried deletes attachment in someone else's answer", js: true do
    click_on 'Logout'
    visit question_path(answer.question)

    within('.answer-attachments') { expect(page).not_to have_link 'Delete' }
  end
end
