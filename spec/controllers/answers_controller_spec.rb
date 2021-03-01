require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    let(:question) { create(:question) }

    before { get :new, params: { question_id: question } }

    it 'assigns a new question.answers to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer).with(question_id: question.id)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new answer in the database'
      it 'redirects to question_path'
    end

    context 'with invalid attributes' do
      it 'does not save the answer'
      it 're-renders new view'
    end
  end
end
