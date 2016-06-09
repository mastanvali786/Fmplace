class ProjectMessage <  ActiveRecord::Base
  include Messageable

  belongs_to :project
  belongs_to :message

  after_create :publish_new_message_created

  def publish_new_message_created
    broadcast("new_message", message)
  end

  def self.project(message_id)
    project_message = where(message_id:message_id).first
    if project_message
      project_message.project
    end
  end
end