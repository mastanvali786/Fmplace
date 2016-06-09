class PayPalIpn
  def self.process params
    result = OpenStruct.new params
    if result.status == "COMPLETED" && result.action_type == "PAY"
      PayPalPendingPayment.process result.pay_key
    end
    if result.txn_type == 'masspay' && result.status_1 == 'Completed'
    	PayPalPendingPayment.process_automatic_withdrawal(result)
    end
  end
end
