module Messageables
  module Project
    def new_message(message)
      project_message = ProjectMessage.new project_id: self.id, message_id:message.id
      project_message.subscribe(buyer)
      project_message.subscribe(seller)
      project_message.save!
    end
  end
end