require 'rails_helper'

feature "The author can delete link in his own question", "
  In order to delete link in my own question
  As an authenticated user
  I'd like to be able to delete link" do
  given(:question) { create(:question) }
  given(:user2) { create(:user) }
  given(:link) { { name: 'My link', url: 'http://127.0.0.1:3000/questions/' } }
  given(:link2) { { name: 'Second link', url: 'http://127.0.0.1:3000/questions/' } }

  background do
    question.links.create(link)
    question.links.create(link2)
  end

  scenario 'Authenticated user deletes any link in they own question', js: true do
    sign_in(question.user)
    visit question_path(question)

    first(".delete-link").click_on 'Delete'

    expect(page).not_to have_link link[:name], href: link[:url]
    expect(page).to have_link link2[:name], href: link2[:url]
  end

  scenario "Authenticated user tried deletes link in someone else's question", js: true do
    sign_in(user2)
    visit question_path(question)

    within('.question-links') { expect(page).not_to have_link 'Delete' }
  end

  scenario "Unauthenticated user tried deletes link in someone else's question", js: true do
    visit question_path(question)

    within('.question-links') { expect(page).not_to have_link 'Delete' }
  end
end
