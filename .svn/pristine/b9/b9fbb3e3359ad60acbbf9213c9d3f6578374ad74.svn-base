module Listeners
  module Requests
    class PayPalDeposits
      def new_pay_pal_deposit_request(request)
        create_deposit_pending_payment request
      end
      private
      def create_deposit_pending_payment request
        current_url = CURRENT_URL_DEPOSIT
        paypal_url = PAYPAL_IPN
        sys_admin = User.sys_admin
        amount = request.amount.to_f
        items = {:name=> 'Deposit Invoice', :unitPrice=>amount, :quantity=>1}
        invoice = PayPalInvoiceSdk.create request.requester_email, items
        if invoice.success?
          amount = invoice.totalAmount/100.0
          paymentRequest = PayPalPaymentsSdk.paymentRequestUrl(
            receiver_email:PAYPAL_MERCHANT_EMAIL,
            amount:amount,
            return_url:current_url,
            ipn_url:paypal_url,
            invoice_id:invoice.invoiceID
          )
          unless paymentRequest.success?
            raise "PayPal Payment Sdk (error):  #{paymentRequest.error.message}"
          end

          data = {
            invoiceId: invoice.invoiceID,
            invoiceUrl: invoice.invoiceURL,
            payerViewUrl: paymentRequest.payerViewUrl
          }
          deposit_request = PayPalDepositInvoice.create!(
            deposit_request_id: request.id,
            sender_id:request.requester_id,
            receiver_id:sys_admin.id,
            amount: amount,
            data:data
          )
          PayPalDepositPendingPayment.create! paymentRequest.pay_key, deposit_request.id
        else
          raise "PayPal Invoice Sdk (error):  #{invoice.error.first.message}"
        end
      end
    end
  end
end