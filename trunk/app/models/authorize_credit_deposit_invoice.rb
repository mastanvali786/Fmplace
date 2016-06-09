class AuthorizeCreditDepositInvoice < DepositInvoice
  # store :data, accessors: [ :payer_view_url]
  def mark_paid!
    paid_on = DateTime.now
    update_attributes paid_on: paid_on
  end
end