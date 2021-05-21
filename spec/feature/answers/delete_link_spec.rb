require 'rails_helper'

feature "The author can delete link in his own answer", "
  In order to delete link in my own answer
  As an authenticated user
  I'd like to be able to delete link" do
  given(:answer) { create(:answer) }
  given(:user2) { create(:user) }
  given(:link) { { name: 'My link', url: 'http://127.0.0.1:3000/answers/' } }
  given(:link2) { { name: 'Second link', url: 'http://127.0.0.1:3000/answers/' } }

  background do
    answer.links.create(link)
    answer.links.create(link2)
  end

  scenario 'Authenticated user deletes any link in they own answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    first(".delete-link").click_on 'Delete'

    expect(page).not_to have_link link[:name], href: link[:url]
    expect(page).to have_link link2[:name], href: link2[:url]
  end

  scenario "Authenticated user tried deletes link in someone else's answer", js: true do
    sign_in(user2)
    visit question_path(answer.question)

    within('.answer-links') { expect(page).not_to have_link 'Delete' }
  end

  scenario "Unauthenticated user tried deletes link in someone else's answer", js: true do
    visit question_path(answer.question)

    within('.answer-links') { expect(page).not_to have_link 'Delete' }
  end
end
