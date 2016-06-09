module Listeners
  class ReleaseFundsPayment
    include Helper
    include Messageable
    def new_release_fund_payment payment
      if payment.credit?
        request = MilestoneReleaseFundRequest.find payment.detail.data[:request_id]
        request.released!
      end
    end
  end
end