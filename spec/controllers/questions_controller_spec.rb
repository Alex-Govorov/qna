require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
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
