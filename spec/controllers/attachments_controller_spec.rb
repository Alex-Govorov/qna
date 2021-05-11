require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:resource) { create(:answer) }

    before do
      resource.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')),
                            filename: 'rails_helper.rb')
    end

    context 'when author' do
      before { login(resource.user) }

      it 'deletes the attachment' do
        expect do
          delete :destroy, params: { id: resource.files.last.id },
                           format: :js
        end.to change(resource.files, :count).by(-1)
      end

      it 'renders delete_attachment view' do
        delete :destroy, params: { id: resource.files.last.id },
                         format: :js
        expect(response).to render_template :delete_attachment
      end
    end

    context 'when not author' do
      let(:user2) { create(:user) }

      before { login(user2) }

      it 'does not deletes the attachment' do
        expect do
          delete :destroy, params: { id: resource.files.last.id },
                           format: :js
        end.to change(resource.files, :count).by(0)
      end
    end
  end
end
