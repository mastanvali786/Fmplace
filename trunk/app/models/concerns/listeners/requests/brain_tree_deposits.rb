module Listeners
  module Requests
    class BrainTreeDeposits
      def new_brain_tree_deposit_request(request)
        create_deposit_pending_payment request
      end
      private
      def create_deposit_pending_payment request
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
        deposit_request = BrainTreeDepositInvoice.create!(
            deposit_request_id: request.id,
            sender_id:request.requester_id,
            receiver_id:sys_admin.id,
            amount: amount
        )
        invoice_id = deposit_request.id
        unique_number = SecureRandom.hex 16
        unique_invoice_id = "#{invoice_id}#{unique_number}"
        data = {
          invoiceId: unique_invoice_id
        }
        deposit_request.update_attributes data: data
      end
    end
  end
end