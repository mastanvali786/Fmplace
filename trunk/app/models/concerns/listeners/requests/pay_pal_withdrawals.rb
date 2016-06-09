module Listeners
  module Requests
    class PayPalWithdrawals
      def new_pay_pal_withdrawal_request(request)
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
        withdrawal_invoice = PayPalWithdrawalInvoice.create!(
          withdrawal_request_id: request.id,
          sender_id:sys_admin.id,
          receiver_id:request.requester_id,
          amount: amount,
        )
        invoice_id = withdrawal_invoice.id
        unique_number = SecureRandom.hex 16
        unique_invoice_id = "#{invoice_id}#{unique_number}"
        paymentRequest = PayPalPaymentsSdk.paymentRequestUrl(
          receiver_email:request.requester_email,
          amount:amount,
          return_url: current_url,
          ipn_url: paypal_url,
          invoice_id:unique_invoice_id
        )
        unless paymentRequest.success?
          raise "PayPal Payment Sdk (error):  #{paymentRequest.error.message}"
        end
        data = {
          invoiceId: unique_invoice_id,
          payer_view_url: paymentRequest.payerViewUrl
        }
        withdrawal_invoice.update_attributes data: data
        PayPalWithdrawalPendingPayment.create! paymentRequest.pay_key, invoice_id
      end
    end
  end
end