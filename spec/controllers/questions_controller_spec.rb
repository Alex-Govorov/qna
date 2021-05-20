require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    it 'populates an array of all questions' do
      question1 = create(:question)
      question2 = create(:question)

      get :index

      expect(assigns(:questions)).to match_array([question1, question2])
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new question in the database' do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create,
               params: { question: attributes_for(:question, :invalid) }
        end.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'when author' do
      before { login(question.user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'when not the author' do
      before { login(user) }

      it 'does not deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'GET #edit' do
    let!(:question) { create(:question, user: user) }

    context 'when author click edit link' do
      before { login(user) }

      it 'renders edit view' do
        get :edit, params: { id: question }, xhr: true
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, user: user) }

    context 'when author with valid attributes' do
      before { login(user) }

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { body: 'new body', title: 'new title' } },
                       format: :js
        question.reload
        expect(question).to have_attributes(body: 'new body', title: 'new title')
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { body: 'new body', title: 'new title' } },
                       format: :js
        expect(response).to render_template :update
      end
    end

    context 'when author with invalid attributes' do
      before { login(user) }

      it 'does not change attributes' do
        expect do
          patch :update,
                params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.not_to change(question, :title)
      end

      it 'renders update view' do
        patch :update,
              params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when not author' do
      let(:user2) { create(:user) }

      before { login(user2) }

      it 'does not change attributes' do
        patch :update, params: { id: question, question: { body: 'new body', title: 'new title' } },
                       format: :js
        question.reload
        expect(question).not_to have_attributes(body: 'new body', title: 'new title')
      end
    end
  end
end
