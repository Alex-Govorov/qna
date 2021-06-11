require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }
  it { should delegate_method(:user_id).to(:votable).with_prefix }

  it { should validate_presence_of(:value).on(:vote) }
  it { should validate_inclusion_of(:value).in_array([-1, 1]).on(:vote) }

  describe 'validates :user_id, numericality' do
    subject(:vote) { create(:vote, :for_answer) }

    it 'validates what user_id is_other_than votable_user_id' do
      expect(vote).to validate_numericality_of(:user_id).is_other_than(vote.votable.user.id)
                                                        .with_message("can't vote for own resource")
    end
  end

  describe 'validates :user, uniqueness' do
    let(:vote) { create(:vote, :for_question) }
    let(:vote2) { described_class.create(user: vote.user, votable: vote.votable, value: 1) }

    it "validates what user can't vote twice for same votable_type and votable_id" do
      vote2.valid?
      expect(vote2.errors[:user]).to include('already voted for this resourse')
    end
  end

  describe '#self.score' do
    let(:vote) { create(:vote, :for_question) }
    let(:question) { vote.votable }

    before { create(:vote, votable: vote.votable) }

    it 'return sum of votes for resource' do
      expect(question.votes.score).to eq 2
    end
  end
end
