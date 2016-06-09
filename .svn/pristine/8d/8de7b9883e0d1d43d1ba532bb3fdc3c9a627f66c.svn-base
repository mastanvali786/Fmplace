module Listeners
  class DepositRequests
    include Helper
    include Messageable
    def new_deposit_request(request)
      broadcast("new_#{request.type.underscore}", request)
      notify_user request
    end
    private
    def notify_user request
      request_path = url_helpers.deposit_request_path request
      request_link = link_to "Deposit", request_path
      template = <<-EOL
        You have requested a #{request.klass.titleize} #{request_link} for #{number_to_currency request.amount}.<br>
        Your balance is added by this amount.<br>
        You will be notified once the transfer is complete.
      EOL
      send_admin_message "Deposit Request", template, request.user_id
    end
  end
end