require 'rails_helper'

feature 'Authenticated user can vote for answer he likes', "
In order to vote for liked resource
As an authenticated user
I'd like to be able to vote
" do
  it_behaves_like "votable", "answer"

  # Всё что ниже - первый вариант без использования shared_examples
  # Удалю после проверки, если ничего глобально переделывать не придётся

  # given(:answer) { create(:answer) }
  # given(:user) { create(:user) }
  # given(:resource) { answer }

  # describe 'Unauthenticated' do
  #   scenario "user tries to vote for answer", js: true do
  #     visit question_path(answer.question)

  #     expect(page).not_to have_css('.vote-control')
  #   end

  #   scenario "user can see answer voting rating", js: true do
  #     create_list(:vote, 3, votable: resource, value: -1)

  #     visit question_path(answer.question)

  #     expect(page).to have_content('-3')
  #   end
  # end

  # describe 'Authenticated', js: true do
  #   let(:vote_up_link) { "/vote_up/#{resource.class}/#{resource.id}" }
  #   let(:vote_down_link) { "/vote_down/#{resource.class}/#{resource.id}" }
  #   let(:vote_reset_link) { "/vote_reset/#{resource.class}/#{resource.id}" }
  #   let(:resource_id) { ".#{resource.class.to_s.downcase}-#{resource.id}-vote" }

  #   background { sign_in user }

  #   scenario "user can vote up for answer" do
  #     visit question_path(answer.question)

  #     click_link(href: vote_up_link)

  #     within(resource_id) do
  #       expect(page).to have_content('1')
  #     end
  #   end

  #   scenario "user can vote down for answer" do
  #     visit question_path(answer.question)

  #     click_link(href: vote_down_link)

  #     within(resource_id) do
  #       expect(page).to have_content('-1')
  #     end
  #   end

  #   scenario "user trying to vote up for his answer" do
  #     click_on('Logout')
  #     sign_in(answer.user)
  #     visit question_path(answer.question)

  #     within(resource_id) do
  #       expect(page).not_to have_css('.vote-control')
  #     end
  #   end

  #   scenario "user trying to vote up for answer twice" do
  #     visit question_path(answer.question)

  #     click_link(href: vote_down_link)

  #     within(resource_id) do
  #       expect(page).not_to have_css('.vote-control')
  #     end
  #   end

  #   scenario "user can undo his vote and vote again" do
  #     visit question_path(answer.question)

  #     within(resource_id) do
  #       click_link(href: vote_down_link)
  #       expect(page).to have_content('-1')

  #       click_link(href: vote_reset_link)
  #       expect(page).to have_content('0')

  #       click_link(href: vote_up_link)
  #       expect(page).to have_content('1')
  #     end
  #   end
  # end
end
