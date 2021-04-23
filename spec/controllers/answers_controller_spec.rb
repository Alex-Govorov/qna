require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) },
                        format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) },
                      format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) },
               format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) },
                      format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'when author' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect do
          delete :destroy, params: { id: answer }, format: :js
        end.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when not the author' do
      before { login(user) }

      it 'does not deletes the answer' do
        expect do
          delete :destroy, params: { id: answer }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'GET #edit' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'when author click edit link' do
      before { login(user) }

      it 'renders edit view' do
        get :edit, params: { id: answer }, xhr: true
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'when author with valid attributes' do
      before { login(user) }

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when author with invalid attributes' do
      before { login(user) }

      it 'does not change attributes' do
        expect do
          patch :update,
                params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(answer, :body)
      end

      it 'renders update view' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when not author' do
      let(:user2) { create(:user) }

      before { login(user2) }

      it 'does not change attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    let!(:answer) { create(:answer) }

    context 'when author of question' do
      before { login(answer.question.user) }

      it 'changes answer attribute best to true' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq true
      end

      it 'renders mark_as_best view' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end

    context 'when not author of question' do
      before { login(user) }

      it 'does not changes answer attribute best to true' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).not_to eq true
      end

      it 'renders mark_as_best view' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end
  end
end
