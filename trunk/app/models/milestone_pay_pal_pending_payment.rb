class MilestonePayPalPendingPayment
  def self.create!(pay_key, invoice_id)
    PayPalPendingPayment.create! handler: "PayPalInvoice", handler_id:invoice_id, pay_key:pay_key
  end
end