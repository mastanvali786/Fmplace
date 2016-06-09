class BrainTreeWithdrawalInvoice < WithdrawalInvoice
  #store :data
  def mark_paid!
    paid_on = DateTime.now
    update_attributes paid_on: paid_on
  end
end