require 'rails_helper'

feature 'User can vew his rewards', "
  In order to view rewards for best answers
  As an authenticated user
  I'd like to be able to view my rewards
  " do
  let(:answer) { create(:answer) }
  let(:answer2) { create(:answer, user: answer.user) }
  let(:reward) { answer.question.build_reward(title: 'Test reward') }
  let(:reward2) { answer2.question.build_reward(title: 'Test reward2') }

  background do
    reward.image.attach(io: File.open(Rails.root.join('spec/support/03.png')),
                        filename: '03.png')
    reward.save
    reward2.image.attach(io: File.open(Rails.root.join('spec/support/03.png')),
                         filename: '03.png')
    reward2.save
    answer.mark_as_best
    answer2.mark_as_best
  end

  scenario 'Authenticated user view his rewards' do
    sign_in(answer.user)

    visit rewards_user_path

    expect(page).to have_content('MyString')
    expect(page).to have_css("img[src*='03.png']")
    expect(page).to have_content('Test reward')
    expect(page).to have_content('Test reward2')
  end

  scenario 'Unathenticated user tries to view rewards' do
    visit rewards_user_path

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
