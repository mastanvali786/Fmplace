module Listeners
  module Requests
    class BrainTreeDeposits
      def new_brain_tree_deposit_request(request)
        create_deposit_pending_payment request
      end
      private
      def create_deposit_pending_payment request
        sys_admin = User.sys_admin
        amount = request.amount.to_f
        deposit_request = BrainTreeDepositInvoice.create!(
            deposit_request_id: request.id,
            sender_id:request.requester_id,
            receiver_id:sys_admin.id,
            amount: amount
        )
      end
    end
  end
end