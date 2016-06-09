module Listeners
  class FundInvoicePayment
    def new_fund_invoice_payment payment
      payment.approve!
    end
  end
end