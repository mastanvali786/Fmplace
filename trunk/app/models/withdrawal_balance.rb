class WithdrawalBalance < ActiveRecord::Base
  validates :withdrawal_id, :balance, presence: true
  belongs_to :withdrawal
end