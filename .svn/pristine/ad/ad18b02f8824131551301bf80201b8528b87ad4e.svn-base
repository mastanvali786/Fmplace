module Messageables
  module User
    def new_user_message(message)
      message_id = message.id
      to_id = message.sender.try(:id)
      if to_id != self.id
        to_id = message.receiver.try(:id)
        if to_id == self.id
          copy = message.receiver_copy!(self)
          message_id = copy.id
          message.update_attribute(:other_message_id,message_id)
        else
          to_id = nil
        end
      end
      UserMessage.create!(user_id: self.id, message_id:message_id) if to_id.present?
    end
  end
end