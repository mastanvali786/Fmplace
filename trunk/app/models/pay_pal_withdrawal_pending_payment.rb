class PayPalWithdrawalPendingPayment
  def self.create!(pay_key, withdrawal_invoice_id)
    PayPalPendingPayment.create! pay_key:pay_key, handler: "PayPalWithdrawalInvoice", handler_id:withdrawal_invoice_id
  end
end