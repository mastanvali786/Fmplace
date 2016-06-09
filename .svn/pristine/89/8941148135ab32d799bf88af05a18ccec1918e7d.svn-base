module Listeners
  class WithdrawalRequests
    include Helper
    include Messageable
    def new_withdrawal_request(request)
      broadcast("new_#{request.type.underscore}", request)
      notify_user request
    end
    private
    def notify_user request
      request_path = url_helpers.withdrawal_request_path request
      request_link = link_to "withdrawal", request_path
      template = <<-EOL
        You have requested a #{request.klass.titleize} #{request_link} for #{number_to_currency request.amount}.<br>
        Your balance is reduced by this amount.<br>
        You will be notified once the transfer is complete.
      EOL
      send_admin_message "Withdrawal Request", template, request.user_id
    end
  end
end