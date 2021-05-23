require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #rewards' do
    before do
      login(user)
      get :rewards
    end

    it 'renders rewards view' do
      expect(response).to render_template :rewards
    end
  end
end
