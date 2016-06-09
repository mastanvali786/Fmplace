module Listeners
  class Messages
    include Messageable
    def new_message(message)
      if message.normal?
        sender = message.sender
        receiver = message.receiver
        [sender, receiver].compact.each do |subscriber|
          #temporary subscribe user
          Wisper.subscribe(subscriber, scope: "Listeners::Messages") do
            broadcast("new_user_message", message)
          end
        end
      end
    end
  end
end