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
    let(:user) { described_class.new(email: 'user1@mail.com', password: '123456') }
    let(:user2) { described_class.new(email: 'user2@mail.com', password: '123456') }
    let(:question) { user.questions.new }

    it 'returns true if resource user is equal to self' do
      expect(user.author_of?(question)).to eq true
    end

    it 'returns false if resource user is not equal to self' do
      expect(user2.author_of?(question)).to eq false
    end
  end
end
