class Balance < ActiveRecord::Base
  validates :user_id, :amount, presence: true
  belongs_to :user

  def self.for_user(user_id)
    find_or_create_by! user_id:user_id
  end

  def available
    amount - pending_withdrawals_amount
  end

  # def payfast_available
  #   amount - payfast_pending_withdrawals_amount
  # end

  def total
    self.amount + completed_withdrawals_amount + featured_payment_amount
  end

  def payfast_total
    self.amount + payfast_completed_withdrawals_amount + featured_payment_amount
  end

  def current
    self.amount
  end

  def request_withdrawal amount
    if can_withdraw? amount
      PayPalWithdrawalRequest.create! amount:amount, balance_id:self.id, user_id:User.current.id, withdraw_type:'Manual'
    end
  end


  def payfast_request_withdrawal amount
    if can_withdraw? amount
      PayFastWithdrawalRequest.create! amount:amount, balance_id:self.id, user_id:User.current.id, withdraw_type:'Manual'
    end
  end

  def authorize_credit_request_withdrawal amount
    if can_withdraw? amount
      AuthorizeCreditWithdrawalRequest.create! amount:amount, balance_id:self.id, user_id:User.current.id, withdraw_type:'Manual'
    end
  end

  def request_deposit amount
    request = PayPalDepositRequest.create! amount:amount, balance_id:self.id, user_id:User.current.id
    request
  end

  def pay_fast_request_deposit amount
    request = PayFastDepositRequest.create! amount:amount, balance_id:self.id, user_id:User.current.id
    request
  end

  def authorize_credit_request_deposit amount
    request = AuthorizeCreditDepositRequest.create! amount:amount, balance_id:self.id, user_id:User.current.id
    request
  end

  def braintree_request_deposit amount
    request = BrainTreeDepositRequest.create! amount:amount, balance_id:self.id, user_id:User.current.id
    request
  end

  def can_withdraw?(amount)
    self.available >= amount
  end

  def adjust!(payment)
    adjust amount:payment.amount, debit:payment.debit?, save:true
  end

  private

  def pending_withdrawals_amount
    paypal_amount = PayPalWithdrawalRequest.pending_requests(self.user_id).sum(:amount)
    payfast_amount = PayFastWithdrawalRequest.pending_requests(self.user_id).sum(:amount)
    paypal_amount + payfast_amount
  end

  def payfast_pending_withdrawals_amount
    paypal_amount = PayPalWithdrawalRequest.pending_requests(self.user_id).sum(:amount)
    payfast_amount = PayFastWithdrawalRequest.pending_requests(self.user_id).sum(:amount)
    paypal_amount + payfast_amount
  end


  def completed_withdrawals_amount
    paypal_amount = PayPalWithdrawalRequest.completed_requests(self.user_id).sum(:amount)
    payfast_amount = PayFastWithdrawalRequest.completed_requests(self.user_id).sum(:amount)
    paypal_amount + payfast_amount
  end

  def payfast_completed_withdrawals_amount
    paypal_amount = PayPalWithdrawalRequest.completed_requests(self.user_id).sum(:amount)
    payfast_amount = PayFastWithdrawalRequest.completed_requests(self.user_id).sum(:amount)
    paypal_amount + payfast_amount
  end

  def featured_payment_amount
    Payment.where(to:self.user_id).featured.sum(:amount)
  end

  def adjust(options={})
    default = {amount:0, save:false}
    params = OpenStruct.new(default.merge options)
    if params.amount > 0 
      if params.debit
        raise "Not Enough Funds To Withdraw" unless can_withdraw?(params.amount)
      end   
      factor = params.debit ? -1 : 1
      self.amount += factor*params.amount
      save! if params.save
    end
  end

  def withdraw! withdraw_amount
    Balance.transaction do
      adjust amount:withdraw_amount, debit:true, save:true
      PayPalWithdrawal.create! user_id:User.current.id, amount:withdraw_amount, balance:self.amount
    end
  end
end