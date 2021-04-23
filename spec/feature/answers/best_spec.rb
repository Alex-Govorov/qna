require 'rails_helper'

feature 'User can choose best answer for his question', "
In order to correct mistakes
As an author of question
I'd like to be able to choose answer as the best
" do
  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }
  given!(:answer2) { create(:answer, question: answer.question) }

  scenario "Unathenticated user tries to choose best answer" do
    visit question_path(answer.question)

    expect(page).not_to have_link 'Best'
  end

  scenario "Unathenticated user can view the best answer", js: true do
    sign_in answer.question.user
    visit question_path(answer.question)

    find("#answer-#{answer.id}").click_on 'Best'
    click_on 'Logout'
    visit question_path(answer.question)

    expect(find('.answers', match: :first)).to have_selector('.best-answer')
  end

  describe 'Authenticated user' do
    background do
      sign_in answer.question.user
      visit question_path(answer.question)
    end

    scenario 'chooses the best answer in his question', js: true do
      find("#answer-#{answer.id}").click_on 'Best'

      expect(find('.answers', match: :first)).to have_selector('.best-answer')
      expect(find('.answers', match: :first)).to have_selector("#answer-#{answer.id}")
    end

    scenario 'chooses the best answer in his question which already has a best answer', js: true do
      find("#answer-#{answer.id}").click_on 'Best'
      find("#answer-#{answer2.id}").click_on 'Best'

      expect(find('.answers', match: :first)).to have_selector('.best-answer')
      expect(find('.answers', match: :first)).to have_selector("#answer-#{answer2.id}")
      expect(find("#answer-#{answer.id}")).not_to have_selector('.best-answer')
    end

    scenario 'tries to choose the best answer in other user question' do
      click_on 'Logout'
      sign_in(user)
      visit question_path(answer.question)

      expect(page).not_to have_link 'Best'
    end
  end
end
