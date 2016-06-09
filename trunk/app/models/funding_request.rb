class FundingRequest < ActiveRecord::Base
  belongs_to :milestone
  belongs_to :user
  validates :user_id, :milestone_id, :sent_at, :status, :type, presence: true
  def funded?
    status == "funded"
  end
  def sent?
    sent_at.present?
  end
end