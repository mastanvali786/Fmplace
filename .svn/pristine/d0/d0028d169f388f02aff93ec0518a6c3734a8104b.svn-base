class PayPalInvoice < MilestoneInvoice
  store :data, accessors: [ :payerViewUrl, :invoiceId, :invoiceUrl]
  def mark_paid!
    paidOn = DateTime.now
    PayPalInvoiceSdk.mark_paid!(self.invoiceId, paidOn)
    update_attributes paidOn: paidOn
  end
  def valid_funded
    details = PayPalInvoiceSdk.invoice_details(self.invoiceId)
    unless details.success?
      raise "PayPal Invoice Sdk: #{details.error}"
    end
    details.paid?
  end
end