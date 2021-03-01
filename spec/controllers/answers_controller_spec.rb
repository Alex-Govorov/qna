require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    it 'assigns a new question.answers to @answer'
    it 'renders new view'
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
