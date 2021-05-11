class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    @resource = file.record
    return head :forbidden unless current_user.author_of?(@resource)

    file.purge
    render "#{file.record_type.pluralize.downcase}/delete_attachment"
  end
end
