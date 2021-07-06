require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context "when not authorized user trying to vote" do
      let(:expected_response) do
        { error: 'You need to sign in or sign up before continuing.' }.to_json
      end

      it 'return Unauthorized status in header' do
        post :create, params: { question_id: question.id, value: 1 }, format: :json
        expect(response.status).to eq 401
      end

      it 'renders JSON response' do
        post :create, params: { question_id: question.id, value: 1 }, format: :json
        expect(response.body).to eq expected_response
      end
    end

    context "when author trying to vote for his resource" do
      before { login(question.user) }

      let(:expected_response) do
        ["User can't vote for own resource"].to_json
      end

      it 'return Unprocessable entity status in header' do
        post :create, params: { question_id: question.id, value: 1 }, format: :json
        expect(response.status).to eq 422
      end

      it 'renders JSON response' do
        post :create, params: { question_id: question.id, value: 1 }, format: :json
        expect(response.body).to eq expected_response
      end
    end

    context "when not author trying to vote twice for same resource" do
      before do
        login(user)
        create(:vote, votable: question, user: user)
      end

      let(:expected_response) do
        ['User already voted for this resourse'].to_json
      end

      it 'does not saves vote in the database' do
        expect do
          post :create, params: { question_id: question.id, value: 1 }, format: :json
        end.to change(question.votes, :count).by(0)
      end

      it 'return Unprocessable entity status in header' do
        post :create, params: { question_id: question.id, value: 1 }, format: :json
        expect(response.status).to eq 422
      end

      it 'renders JSON response' do
        post :create, params: { question_id: question.id, value: 1 }, format: :json
        expect(response.body).to eq expected_response
      end
    end

    context 'when none author voting up' do
      before { login(user) }

      let(:expected_response) do
        { resource_type: question.class.to_s.downcase,
          resource_id: question.id,
          can_vote: false,
          can_reset: true,
          score: 1 }.to_json
      end

      it 'saves a vote in the database' do
        expect do
          post :create, params: { question_id: question.id, value: 1 }, format: :json
        end.to change(question.votes, :count).by(1)
      end

      it 'renders JSON response' do
        post :create, params: { question_id: question.id, value: 1 }, format: :json
        expect(response.body).to eq expected_response
      end
    end
  end

  describe 'DELETE #destroy' do
    before { create(:vote, votable: question, user: user, value: 1) }

    context 'when not authorized user trying to vote reset' do
      let(:expected_response) do
        { error: 'You need to sign in or sign up before continuing.' }.to_json
      end

      it 'return Unauthorized status in header' do
        delete :destroy, params: { question_id: question.id }, format: :json
        expect(response.status).to eq 401
      end

      it 'renders JSON response' do
        delete :destroy, params: { question_id: question.id }, format: :json
        expect(response.body).to eq expected_response
      end
    end

    context 'when authorized user vote reseting' do
      before { login(user) }

      let(:expected_response) do
        { resource_type: question.class.to_s.downcase,
          resource_id: question.id,
          can_vote: true,
          can_reset: false,
          score: 0 }.to_json
      end

      it 'deletes vote from database' do
        expect do
          delete :destroy, params: { question_id: question.id }, format: :json
        end.to change(question.votes, :count).by(-1)
      end

      it 'renders JSON response' do
        delete :destroy, params: { question_id: question.id }, format: :json
        expect(response.body).to eq expected_response
      end
    end
  end

  describe 'GET #show' do
    context 'when not authorized user trying to get vote status' do
      let(:expected_response) do
        { error: 'You need to sign in or sign up before continuing.' }.to_json
      end

      it 'return Unauthorized status in header' do
        get :show, params: { question_id: question.id }, format: :json
        expect(response.status).to eq 401
      end

      it 'renders JSON response' do
        get :show, params: { question_id: question.id }, format: :json
        expect(response.body).to eq expected_response
      end
    end

    context 'when authorized user requested vote status' do
      before do
        login(question.user)
        create(:vote, votable: question, user: user, value: -1)
      end

      let(:expected_response) do
        { resource_type: question.class.to_s.downcase,
          resource_id: question.id,
          can_vote: false,
          can_reset: false,
          score: -1 }.to_json
      end

      it 'renders JSON response' do
        get :show, params: { question_id: question.id }, format: :json
        expect(response.body).to eq expected_response
      end
    end
  end
end
