class PendingPayment < ActiveRecord::Base
  validates :pay_key, :handler, :handler_id, :type, presence: true
  scope :pending, -> {where processed: false }
  def self.process pay_key
    pending_payment = PendingPayment.pending.where(pay_key:pay_key).first
    pending_payment.paid! if pending_payment.present?
  end

  def self.process_automatic_withdrawal(result)
    setting = AccountSetting.where(paypal_email: result.receiver_email_1).first
    user = setting.user
    requests = user.withdrawal_requests.pending_auto_withdrawals
    request = requests.where(amount: result.payment_gross_1.to_f).first if requests
    Rails.logger.info 'Auto Withdrawal request'
    Rails.logger.info request.inspect
    if request
      invoice = request.invoice if request
      pay_key = invoice.pay_key if invoice
      pending_payment = PendingPayment.pending.where(pay_key:pay_key).first
      if pending_payment.present?
        request.completed!
        invoice.paid!(result.masspay_txn_id_1)
        pending_payment.update_attribute :processed, true
      end
    end
  end

  protected
  def self.paid!
    raise "override this method to verify and to process a payment that's been paid"
  end
  def processed!
    update_column :processed, true
  end
end