module Listeners
  class DepositInvoices
    include Messageable
    def deposit_invoice_paid(invoice)
      request = invoice.request
      data = {
        transaction_id:invoice.transaction_id,
        request_id: request.id
      }
      params = {
        to: request.requester_id, amount: invoice.amount
      }
      payment = Payments::Deposit.create_credit params, data
      broadcast("new_deposit", payment)
    end
  end
end