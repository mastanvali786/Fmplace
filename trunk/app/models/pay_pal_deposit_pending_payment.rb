class PayPalDepositPendingPayment
  def self.create!(pay_key, deposit_invoice_id)
    PayPalPendingPayment.create! pay_key:pay_key, handler: "PayPalDepositInvoice", handler_id:deposit_invoice_id
  end
end