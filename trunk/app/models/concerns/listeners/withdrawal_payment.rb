module Listeners
  class WithdrawalPayment
    include Helper
    def new_withdrawal payment
      request = WithdrawalRequest.find payment.detail.request_id
      WithdrawalRequest.transaction do
        request.completed!
        payment.approve!
        notify_user request
      end
    end
    private
    def notify_user request
      request_path = url_helpers.withdrawal_request_path request
      request_link = link_to "withdrawal", request_path
      template = <<-EOL
        Your #{request.klass.titleize} #{request_link} for #{number_to_currency request.amount};<br>
        has been fulfilled.
      EOL
      send_admin_message "Withdrawal Complete", template, request.user_id
    end
  end
end