require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:answer) }

    it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
    it { should validate_presence_of(:body) }
  end

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best' do
    let!(:answer) { create(:answer) }
    let!(:answer2) { create(:answer, question: answer.question) }
    let(:reward) { answer.question.build_reward(title: 'Test reward') }

    before do
      reward.image.attach(io: File.open(Rails.root.join('spec/support/03.png')),
                          filename: '03.png')
      reward.save
    end

    it "set all other question answers best attribute to false" do
      answer2.update(best: true)

      answer.mark_as_best
      answer2.reload

      expect(answer2.best).to eq false
    end

    it "set best attribute to true
    if susscessfully update all answers best attribute to false in transaction block" do
      answer.mark_as_best
      answer.reload

      expect(answer.best).to eq true
    end

    it "not set best attribute to true
     if unsusscessfully update all answers best attribute to false in transaction block" do
       answer.update_attribute(:body, nil) # rubocop:disable Rails/SkipsModelValidations
       expect { answer.mark_as_best }.to raise_error(ActiveRecord::RecordInvalid)
     end

    it "update question reward user to answer user" do
      answer.mark_as_best

      expect(answer.question.reward.user).to eq answer.user
    end
  end
end
