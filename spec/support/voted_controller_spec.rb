require 'rails_helper'

shared_examples "voted" do |method|
  context "when not authorized user trying to #{method}" do
    let(:expected_response) do
      { error: 'You need to sign in or sign up before continuing.' }.to_json
    end

    it 'return Unauthorized status in header' do
      post method.to_sym, params: { resource_type: question.class.to_s,
                                    resource_id: question.id }, format: :json
      expect(response.status).to eq 401
    end

    it 'renders JSON response' do
      post method.to_sym, params: { resource_type: question.class.to_s,
                                    resource_id: question.id }, format: :json
      expect(response.body).to eq expected_response
    end
  end

  context "when author trying to #{method} for his resource" do
    before { login(question.user) }

    let(:expected_response) do
      ["User can't vote for own resource"].to_json
    end

    it 'return Unprocessable entity status in header' do
      post method.to_sym, params: { resource_type: question.class.to_s, resource_id: question.id },
                          format: :json
      expect(response.status).to eq 422
    end

    it 'renders JSON response' do
      post method.to_sym, params: { resource_type: question.class.to_s, resource_id: question.id },
                          format: :json
      expect(response.body).to eq expected_response
    end
  end

  context "when not author trying to #{method} twice for same resource" do
    before do
      login(user)
      create(:vote, votable: question, user: user)
    end

    let(:expected_response) do
      ['User already voted for this resourse'].to_json
    end

    it 'does not saves vote in the database' do
      expect do
        post method.to_sym, params: { resource_type: question.class.to_s,
                                      resource_id: question.id }, format: :json
      end.to change(question.votes, :count).by(0)
    end

    it 'return Unprocessable entity status in header' do
      post method.to_sym, params: { resource_type: question.class.to_s, resource_id: question.id },
                          format: :json
      expect(response.status).to eq 422
    end

    it 'renders JSON response' do
      post method.to_sym, params: { resource_type: question.class.to_s, resource_id: question.id },
                          format: :json
      expect(response.body).to eq expected_response
    end
  end
end
