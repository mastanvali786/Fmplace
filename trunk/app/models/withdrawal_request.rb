class WithdrawalRequest < ActiveRecord::Base
  belongs_to :user
  include Messageable
  validates :user_id, :amount, :status, :type,  presence: true
  has_one :invoice, class_name: "WithdrawalInvoice"
  scope :pending, -> { where(status: 'Pending', withdraw_type: 'Manual') }
  scope :completed, -> { where(status: 'Completed', withdraw_type: 'Manual') }
  scope :auto_withdrawals, -> { where(withdraw_type: 'Auto') }
  scope :pending_auto_withdrawals, -> { where(status: 'Pending', withdraw_type: 'Auto') }
  scope :manual_withdrawals, -> { where(withdraw_type: 'Manual') }
  after_create :publish_new_withdrawal_request
  def klass
    type.sub("WithdrawalRequest",'')
  end
  def requested_on
    created_at
  end
  def requester_id
    user_id
  end
  def requester
    user
  end

  def requester_email
    user.paypal_email
  end

  def invoiced?
    invoice.present?
  end
  def paid?
    invoice.paid?
  end
  def pending?
    status.downcase == "pending"
  end
  def completed!
    update_attributes status: "Completed"
  end
  def completed?
     status.downcase == "completed"
  end

  def self.pending_requests user_id
    where(user_id:user_id).where(status: "Pending")
  end

  def self.completed_requests user_id
    where(user_id:user_id).where(status: "Completed")
  end

  def self.pay_fast_withdraw_request(params)
     withdraw = WithdrawalRequest.find_by_id(params[:custom_int1])
     if withdraw.present?
      withdraw.update_attributes(status: "Completed")
     end
  end

  private
  def publish_new_withdrawal_request
    broadcast("new_withdrawal_request", self)
  end
end