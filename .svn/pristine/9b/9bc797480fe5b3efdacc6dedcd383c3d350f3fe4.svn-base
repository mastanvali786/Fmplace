module Listeners
  class DepositPayment
    include Helper
    def new_deposit payment
      request = DepositRequest.find payment.detail.request_id
      DepositRequest.transaction do
        request.completed!
        payment.approve!
        notify_user request
      end
    end
    private
    def notify_user request
      request_path = url_helpers.deposit_request_path request
      request_link = link_to "Deposit", request_path
      template = <<-EOL
        Your #{request.klass.titleize} #{request_link} for #{number_to_currency request.amount};<br>
        has been fulfilled.
      EOL
      send_admin_message "Deposit Complete", template, request.user_id
    end
  end
end