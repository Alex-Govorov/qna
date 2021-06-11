require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:nullify) }
    it { should have_many(:votes).dependent(:destroy) }
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
end
