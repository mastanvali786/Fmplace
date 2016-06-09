class MilestoneReleaseFundRequest < ActiveRecord::Base
  belongs_to :milestone
  belongs_to :buyer, class_name: "User", foreign_key: "buyer_id"
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"
  include Messageable
  after_create :publish_new_milestone_release_fund_request
  after_create :check_for_referral_transaction
  validates :buyer_id, :seller_id, :milestone_id, presence: true

  def sent_at
    created_at
  end
  
  def sent?
    sent_at.present?
  end

  def released!
    update_column :released, true
  end

  def declined_request?
    pay = []
    PaymentDetail.all.map{ |pd| pay << pd if pd.request_id == id }.compact
    declined_count = pay.map(&:payment).map(&:declined)
    declined_count = declined_count.count(true) if declined_count
    if declined_count >= 1
      true
    else
      false
    end
  end


  private

  def publish_new_milestone_release_fund_request
    broadcast("new_milestone_release_fund_request", self)
  end

  # check_whether_referral_client
  def check_for_referral_transaction
    client = self.buyer
    if client.ref_id?
      if client.referral_bonus == false
        client.update_attributes(referral_bonus: true)
        broadcast("new_referral_program_request", self)
      end
    end
  end

end