require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '#author_of?(resource)' do
    let(:user) { described_class.create(email: 'user1@mail.com', password: '123456') }
    let(:user2) { described_class.create(email: 'user2@mail.com', password: '123456') }
    let(:question) { user.questions.create }

    it 'returns true if resource user is equal to self' do
      expect(user).to be_author_of(question)
    end

    it 'returns false if resource user is not equal to self' do
      expect(user2).not_to be_author_of(question)
    end
  end

  describe '#rewards' do
    let(:answer) { create(:answer) }
    let(:answer2) { create(:answer, user: answer.user) }
    let(:reward) { answer.question.build_reward(title: 'Test reward') }
    let(:reward2) { answer2.question.build_reward(title: 'Test reward2') }
    let(:answer3) { create(:answer, question: answer.question) }

    before do
      reward.image.attach(io: File.open(Rails.root.join('spec/support/03.png')),
                          filename: '03.png')
      reward.save
      reward2.image.attach(io: File.open(Rails.root.join('spec/support/03.png')),
                           filename: '03.png')
      reward2.save
      answer.mark_as_best
      answer2.mark_as_best
    end

    it 'returns array of user rewards for best answer' do
      expect(answer.user.rewards).to match_array [reward, reward2]
    end

    it 'does not returns user rewards for best answer with other user in best answer' do
      answer3.mark_as_best

      expect(answer.user.rewards).not_to match_array [reward, reward2]
    end
  end
end
