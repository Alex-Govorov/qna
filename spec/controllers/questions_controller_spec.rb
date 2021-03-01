require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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
