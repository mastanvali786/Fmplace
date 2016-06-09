class PayPalFundingRequest < MilestoneFundingRequest
  def invoice!(receiver, settings=nil)
    current_url =  settings[:current_url]
    paypal_ipn_url = settings[:paypal_ipn_url]
    unless invoiced?
      invoice = PayPalInvoiceSdk.create_milestone_invoice receiver.email, self.milestone
      if invoice.success?
        request_sent!
        amount = invoice.totalAmount/100.0
        paymentRequest = PayPalPaymentsSdk.paymentRequestUrl(
          receiver_email:AppConfig.app.sdk.paypal.merchant_email,#receiver.email,
          amount:amount,
          return_url:current_url,
          ipn_url:paypal_ipn_url,
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

        pay_pal_invoice = PayPalInvoice.create!(
                              funding_request:self,
                              sender_id:self.sender.try(:id),
                              receiver_id:receiver.id,
                              amount: amount,
                              data:data
                             )
        MilestonePayPalPendingPayment.create! paymentRequest.pay_key, pay_pal_invoice.id
      else
        raise "PayPal Invoice Sdk (error):  #{invoice.error.first.message}"
      end
      reload
    end
    self.invoice
  end
end