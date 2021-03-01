require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #new' do
    it 'assigns a new Question to @question'
    it 'renders new view'
  end

  describe 'GET #show' do
    it 'assigns the requested question to @question'
    it 'renders show view'
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new question in the database'
      it 'redirects to show view'
    end

    context 'with invalid attributes' do
      it 'does not save the question'
      it 're-renders new view'
    end
  end
end
