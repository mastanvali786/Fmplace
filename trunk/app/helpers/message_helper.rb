module MessageHelper
  def message_type_url(message)
    if message.project?
      project_url message.project
    end
  end
end
