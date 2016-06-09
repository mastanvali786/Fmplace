class Feedback < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "to_id"
  belongs_to :project
  belongs_to :from_feedback, class_name: 'User', foreign_key: "from_id"
  belongs_to :guest_user, class_name: 'GuestUser', foreign_key: "guest_user_id"
  validates :to_id, :presence => true
  #after_create :send_email_admin
  scope :pending, ->   { where(approved: false) }
  scope :approved, ->   { where(approved: true) }

  def rating
  	sum = quality_work + responsiveness + professionalism + expertise + cost + schedule
  	avg = (sum/6.0).round(1)
  end

  def send_email_admin
    # OverhaulMailer.delay.notify_admin_feedback_complete(self)
    # OverhaulMailer.delay.notify_seller_feedback_posted(self)
    # OverhaulMailer.delay.send_email_reviewer_after_feedback(self)
  end

  def given_by_name
    if guest_user.present?
      guest_user.try(:name)
    else
      from_feedback.try(:full_name)
    end
  end

  def given_by_name_short
    if guest_user.present?
      guest_user.try(:name)
    else
      from_feedback.try(:first_name)
    end
  end

  def given_by_email
    if guest_user.present?
      guest_user.try(:email)
    else
      from_feedback.try(:email)
    end
  end
end
