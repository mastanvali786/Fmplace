class DepositRequest < ActiveRecord::Base
	belongs_to :user
	include Messageable
  validates :user_id, :amount, :status, :type,  presence: true
  has_one :invoice, class_name: "DepositInvoice"
  scope :pending, -> { where(status: 'Pending') }
  scope :completed, -> { where(status: 'Completed') }
  after_create :publish_new_deposit_request

  def klass
    type.sub("DepositRequest",'')
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

  def self.pending_requests user_id
    where(user_id:user_id).where(status: "Pending")
  end

  def self.completed_requests user_id
    where(user_id:user_id).where(status: "Completed")
  end

  def self.pay_fast_deposit_request(params)
    deposit = DepositRequest.find_by_id(params[:custom_int1])
     if deposit.present?
      balance = deposit.user.balance
      new_balance = balance.amount.to_s.to_d + params[:amount_gross].to_s.to_d
      balance.update_attributes(amount: new_balance)
     end
  end

  def self.authorize_credit_deposit_request(params)
    deposit = DepositRequest.find_by_id(params[:x_request_id])
    invoice =  DepositInvoice.find_by_id(params[:x_invoice_num])
    if invoice.present?
      invoice.update_attributes(transaction_id: params[:x_trans_id], paid_on: Time.now)
    end
     if deposit.present?
      balance = deposit.user.balance
      new_balance = balance.amount.to_s.to_d + params[:x_amount].to_s.to_d
      balance.update_attributes(amount: new_balance)
     end
  end

  def self.braintree_deposit_request(params, invoice)
    invoice =  DepositInvoice.find_by_id(invoice.id)
    deposit = invoice.request
    if invoice.present?
      invoice.update_attributes(transaction_id: params.transaction.id, paid_on: Time.now, data: params)
    end
     if deposit.present?
      balance = deposit.user.balance
      new_balance = balance.amount.to_s.to_d + params.transaction.amount.to_s.to_d
      balance.update_attributes(amount: new_balance)
     end
  end


  private
  def publish_new_deposit_request
    broadcast("new_deposit_request", self)
  end
end
