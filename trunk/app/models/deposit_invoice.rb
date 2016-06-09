class DepositInvoice < ActiveRecord::Base
	include Messageable
  belongs_to :deposit_request
  validates :deposit_request_id, presence: true
  belongs_to :sender, class_name:"User", foreign_key: "sender_id"
  validates :sender_id, :receiver_id, :amount, :type, presence:true
  def paid!(transaction_id)
    set_transaction_id transaction_id
    mark_paid!
    broadcast('deposit_invoice_paid', self)
  end
  def paid?
    paid_on.present?
  end
  def request
    deposit_request
  end

  def payerViewUrl
    data[:payer_view_url]
  end

  def paidOn
    paid_on
  end

  def payer?(user)
    sender == user
  end

  def pay_key
    data[:payer_view_url].split('=').last if data[:payer_view_url]
  end

  def pay_url
    data[:payerViewUrl]
  end
  
  private
  def mark_paid!
    raise "This method should be overriden to mark invoice as paid and set paid on date"
  end
  def set_transaction_id transaction_id
    update_column :transaction_id, transaction_id
  end
end
