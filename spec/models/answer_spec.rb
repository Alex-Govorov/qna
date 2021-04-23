require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { build(:answer) }

    it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
    it { should validate_presence_of(:body) }
  end

  describe '#mark_as_best' do
    let!(:answer) { create(:answer) }
    let!(:answer2) { create(:answer, question: answer.question) }

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
       answer.update_attribute(:body, nil)
       # Не придумал, как лучше тестировать не удачную транзакцию
       answer.mark_as_best
       answer.reload

       expect(answer.best).to eq false
     end
  end
end
