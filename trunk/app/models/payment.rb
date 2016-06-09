class Payment < ActiveRecord::Base
  validates :to, :amount, :type, :klass, presence: true
  belongs_to :receiver, class_name:"User", foreign_key: :to
  has_one :detail, class_name:"PaymentDetail"
  has_one :payment_balance
  include Messageable
  scope :approved, -> { where(approved: true) }
  scope :declined, ->  { where(declined: true) }
  scope :pending, ->  { where(approved: false, declined: false) }
  scope :credits, ->  { where(type: 'Credit') }
  scope :debits, ->  { where(type: 'Debit') }
  scope :featured, -> { where(klass: 'FeatureProposal') }

  def approve!(approver=User.sys_admin)
    Payment.transaction do
      receiver.balance.adjust! self
      update_columns approved: true, approvedBy: approver.id, approvedOn:Time.now
      broadcast("new_transaction", self)
    end
  end

  def approve_bonus!(approver=User.sys_admin)
    Payment.transaction do
      receiver.balance.adjust! self
      update_columns approved: true, approvedBy: approver.id, approvedOn:Time.now
    end
  end

  def transactional?
    if detail.try(:transaction_id)
      true
    else
      false
    end
  end

  def transaction_id
    detail.transaction_id
  end

  def balance
    payment_balance.try(:balance)
  end

  def approver
   if User.sys_admin?(approvedBy)
     User.sys_admin
   else
     User.find approvedBy
   end
 end

  def feature_transaction
    broadcast("new_transaction", self)
  end

 def status
  if approved?
    'Completed'
  else
    'Pending'
  end
end

def date
  approvedOn
end

def credit?
  type.downcase == "credit"
end

def debit?
  type.downcase == "debit"
end

def milestone
  detail.try(:release_request).try(:milestone)
end

def project
  milestone.try(:project)
end

def milestone?
  detail.try(:release_request).try(:milestone).present?
end

def project?
  milestone.try(:project).present?
end

def milestone_invoice
  MilestoneInvoice.where(transaction_id: detail.transaction_id)
end

end