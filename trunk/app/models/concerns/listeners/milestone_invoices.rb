module Listeners
  class MilestoneInvoices
    include Messageable
    def milestone_invoice_funded(invoice)
      data = {
        transaction_id:invoice.transaction_id
      }
      params = {
        to: invoice.receiver_id, amount: invoice.amount
      }
      payment = Payments::FundInvoice.create_credit params, data
      broadcast("new_fund_invoice_payment", payment)
    end
  end
end