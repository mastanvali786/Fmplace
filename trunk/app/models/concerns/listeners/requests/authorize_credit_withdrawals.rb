module Listeners
  module Requests
    class AuthorizeCreditWithdrawals
      def new_authorize_credit_withdrawal_request(request)
        create_withdrawal_pending_payment request
      end
      private
      def create_withdrawal_pending_payment request
        if User.current && User.current.ipn_settings
          settings = User.current.ipn_settings
          current_url = settings.current_url
          paypal_url = settings.paypal_ipn_url
        else
          current_url = CURRENT_URL
          paypal_url = PAYPAL_IPN
        end
        sys_admin = User.sys_admin
        amount = request.amount.to_f
        withdrawal_invoice = AuthorizeCreditWithdrawalInvoice.create!(
          withdrawal_request_id: request.id,
          sender_id:sys_admin.id,
          receiver_id:request.requester_id,
          amount: amount,
        )
        invoice_id = withdrawal_invoice.id
        unique_number = SecureRandom.hex 16
        unique_invoice_id = "#{invoice_id}#{unique_number}"
        data = {
          invoiceId: unique_invoice_id
        }
        withdrawal_invoice.update_attributes data: data
      end
    end
  end
end