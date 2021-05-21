require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:resource) { create(:answer) }

    before do
      resource.links.create(name: 'Test link', url: 'http://127.0.0.1:3000/questions/13')
      resource.links.create(name: 'Test link2', url: 'http://127.0.0.1:3000/questions/13')
    end

    context 'when author' do
      before { login(resource.user) }

      it 'deletes the link' do
        expect do
          delete :destroy, params: { id: resource.links.last.id },
                           format: :js
        end.to change(resource.links, :count).by(-1)
      end

      it 'renders link view' do
        delete :destroy, params: { id: resource.links.last.id },
                         format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when not author' do
      let(:user2) { create(:user) }

      before { login(user2) }

      it 'does not deletes the link' do
        expect do
          delete :destroy, params: { id: resource.links.last.id },
                           format: :js
        end.to change(resource.links, :count).by(0)
      end
    end
  end
end
