module Listeners
  class WithdrawalInvoices
    include Messageable
    def withdrawal_invoice_paid(invoice)
      request = invoice.request
      data = {
        transaction_id:invoice.transaction_id,
        request_id: request.id
      }
      params = {
        to: request.requester_id, amount: invoice.amount
      }
      payment = Payments::Withdrawal.create_debit params, data
      broadcast("new_withdrawal", payment)
    end
  end
end