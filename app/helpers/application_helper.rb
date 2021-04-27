module ApplicationHelper
  def delete_attachment_link(resource, file_id)
    "/#{resource.class.to_s.pluralize.downcase}/#{resource.id}/delete_attachment?file=#{file_id}"
  end
end
