require 'rails_helper'

shared_examples "votable" do |votable|
  given(:resource) { create(votable.to_sym) }
  given(:user) { create(:user) }
  given(:question) { defined?(resource.question) ? resource.question : resource }

  describe 'Unauthenticated' do
    scenario "user tries to vote for #{votable}", js: true do
      visit question_path(question)

      expect(page).not_to have_css('.vote-control')
    end

    scenario "user can see #{votable} voting rating", js: true do
      create_list(:vote, 3, votable: resource, value: -1)

      visit question_path(question)

      expect(page).to have_content('-3')
    end
  end

  describe 'Authenticated', js: true do
    let(:vote_up_link) { "/#{resource.class.to_s.downcase.pluralize}/#{resource.id}/vote/1" }
    let(:vote_down_link) { "/#{resource.class.to_s.downcase.pluralize}/#{resource.id}/vote/-1" }
    let(:vote_reset_link) { "/#{resource.class.to_s.downcase.pluralize}/#{resource.id}/vote" }
    let(:resource_id) { ".#{resource.class.to_s.downcase}-#{resource.id}-vote" }

    background { sign_in user }

    scenario "user can vote up for #{votable}" do
      visit question_path(question)

      click_link(href: vote_up_link)

      within(resource_id) do
        expect(page).to have_content('1')
      end
    end

    scenario "user can vote down for #{votable}" do
      visit question_path(question)

      click_link(href: vote_down_link)

      within(resource_id) do
        expect(page).to have_content('-1')
      end
    end

    scenario "user trying to vote up for his #{votable}" do
      click_on('Logout')
      sign_in(resource.user)
      visit question_path(question)

      within(resource_id) do
        expect(page).not_to have_css('.vote-control')
      end
    end

    scenario "user trying to vote up for #{votable} twice" do
      visit question_path(question)

      click_link(href: vote_down_link)

      within(resource_id) do
        expect(page).not_to have_css('.vote-control')
      end
    end

    scenario "user can undo his vote and vote again" do
      visit question_path(question)

      within(resource_id) do
        click_link(href: vote_down_link)
        expect(page).to have_content('-1')

        click_link(href: vote_reset_link)
        expect(page).to have_content('0')

        click_link(href: vote_up_link)
        expect(page).to have_content('1')
      end
    end
  end
end
