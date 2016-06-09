class MilestoneFundingRequest < ActiveRecord::Base
  belongs_to :milestone
  attr_accessor :skip_broadcast
  belongs_to :sender, class_name:"User", foreign_key: :user_id
  include Messageable
  has_one :invoice, class_name: "MilestoneInvoice"
  after_create :publish_new_milestone_funding_request
  
  validates :user_id, presence:true, unless: Proc.new { |request|  request.user_id == User.sys_admin.id }
  validates  :milestone_id, :type, presence: true

  def funded?
    invoice.try(:funded?)
  end
  def request_sent!
    raise "Request already sent" if sent_at.present?
    update_column(:sent_at, DateTime.now)
  end
  def sent?
    sent_at.present?
  end
  def invoiced?
    self.invoice.present?
  end
  def invoice!(receiver)
    raise "This method should be overriden to create and return an invoice"
  end
  def broadcast_new_request
    self.skip_broadcast = false
    publish_new_milestone_funding_request
  end
  private
  def publish_new_milestone_funding_request
    broadcast("new_milestone_funding_request", self) unless skip_broadcast
  end
end