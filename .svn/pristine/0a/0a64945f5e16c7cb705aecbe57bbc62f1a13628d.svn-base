class WithdrawalInvoice < ActiveRecord::Base
  include Messageable
  belongs_to :withdrawal_request
  validates :withdrawal_request_id, presence: true
  validates :sender_id, :receiver_id, :amount, :type, presence:true
  def paid!(transaction_id)
    set_transaction_id transaction_id
    mark_paid!
    broadcast('withdrawal_invoice_paid', self)
  end
  def paid?
    paid_on.present?
  end
  def request
    withdrawal_request
  end

  def pay_key
    data[:payer_view_url].split('=').last if data[:payer_view_url]
  end
  
  private
  def mark_paid!
    raise "This method should be overriden to mark invoice as paid and set paid on date"
  end
  def set_transaction_id transaction_id
    update_column :transaction_id, transaction_id
  end
end