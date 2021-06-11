require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #vote_up' do
    it_behaves_like "voted", "vote_up"

    context 'when none author voting up' do
      before { login(user) }

      let(:expected_response) do
        { votable_type: question.class.to_s,
          votable_id: question.id.to_s,
          can_vote: false,
          can_reset: true,
          score: 1 }.to_json
      end

      it 'saves a vote in the database' do
        expect do
          post :vote_up, params: { resource_type: question.class.to_s, resource_id: question.id },
                         format: :json
        end.to change(question.votes, :count).by(1)
      end

      it 'renders JSON response' do
        post :vote_up, params: { resource_type: question.class.to_s, resource_id: question.id },
                       format: :json
        expect(response.body).to eq expected_response
      end
    end
  end

  describe 'POST #vote_down' do
    it_behaves_like "voted", "vote_down"

    context 'when none author voting down' do
      before { login(user) }

      let(:expected_response) do
        { votable_type: question.class.to_s,
          votable_id: question.id.to_s,
          can_vote: false,
          can_reset: true,
          score: -1 }.to_json
      end

      it 'saves a vote in the database' do
        expect do
          post :vote_down, params: { resource_type: question.class.to_s, resource_id: question.id },
                           format: :json
        end.to change(question.votes, :count).by(1)
      end

      it 'renders JSON response' do
        post :vote_down, params: { resource_type: question.class.to_s, resource_id: question.id },
                         format: :json
        expect(response.body).to eq expected_response
      end
    end
  end

  describe 'DELETE #vote_reset' do
    before { create(:vote, votable: question, user: user, value: 1) }

    context 'when not authorized user trying to vote reset' do
      let(:expected_response) do
        { error: 'You need to sign in or sign up before continuing.' }.to_json
      end

      it 'return Unauthorized status in header' do
        post :vote_up, params: { resource_type: question.class.to_s, resource_id: question.id },
                       format: :json
        expect(response.status).to eq 401
      end

      it 'renders JSON response' do
        delete :vote_reset, params: { resource_type: question.class.to_s,
                                      resource_id: question.id }, format: :json
        expect(response.body).to eq expected_response
      end
    end

    context 'when authorized user vote reseting' do
      before { login(user) }

      let(:expected_response) do
        { votable_type: question.class.to_s,
          votable_id: question.id.to_s,
          can_vote: true,
          can_reset: false,
          score: 0 }.to_json
      end

      it 'deletes vote from database' do
        expect do
          delete :vote_reset, params: { resource_type: question.class.to_s,
                                        resource_id: question.id }, format: :json
        end.to change(question.votes, :count).by(-1)
      end

      it 'renders JSON response' do
        delete :vote_reset, params: { resource_type: question.class.to_s,
                                      resource_id: question.id }, format: :json
        expect(response.body).to eq expected_response
      end
    end
  end

  describe 'GET #vote_status' do
    context 'when not authorized user trying to vote status' do
      let(:expected_response) do
        { error: 'You need to sign in or sign up before continuing.' }.to_json
      end

      it 'return Unauthorized status in header' do
        post :vote_up, params: { resource_type: question.class.to_s, resource_id: question.id },
                       format: :json
        expect(response.status).to eq 401
      end

      it 'renders JSON response' do
        get :vote_status, params: { resource_type: question.class.to_s,
                                    resource_id: question.id }, format: :json
        expect(response.body).to eq expected_response
      end
    end

    context 'when authorized user requested vote status' do
      before do
        login(question.user)
        create(:vote, votable: question, user: user, value: -1)
      end

      let(:expected_response) do
        { votable_type: question.class.to_s,
          votable_id: question.id.to_s,
          can_vote: false,
          can_reset: false,
          score: -1 }.to_json
      end

      it 'renders JSON response' do
        get :vote_status, params: { resource_type: question.class.to_s, resource_id: question.id },
                          format: :json
        expect(response.body).to eq expected_response
      end
    end
  end
end
