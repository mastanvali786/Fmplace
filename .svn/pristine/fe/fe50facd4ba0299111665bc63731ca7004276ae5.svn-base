class PayPalPendingPayment < PendingPayment
  def paid!
    details = PayPalPaymentsSdk.get_details pay_key
    if details.success?
      if details.paid?
        handler = self.handler.constantize.find self.handler_id
        handler.paid! details.transactionId
        processed!
     end
    else
      raise "PayPal Payments Sdk: #{details.error}"
    end
  end
end