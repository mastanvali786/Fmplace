module Listeners
  class MilestoneFunds
    include Helper
    def new_milestone_release_fund_request(request)
      @seller_id = request.seller_id
      @milestone_path = milestone_path request.milestone
      Payments::ReleaseFund.create_debit to: request.buyer_id, amount: request.amount
      data = {request_id:request.id}
      # Taking 5% for overhaul admin
      credit_amount = admin_percentage(request)
      params =  {to: @seller_id , amount: credit_amount}
      Payments::ReleaseFund.create_credit params, data
      notify_contractor
    end

    def new_referral_program_request(request)
      @buyer = request.buyer
      @referral = @buyer.referral
      bonus_amount = 10
      Payments::ReleaseFund.create_referal_bonus to: @referral.id , amount: bonus_amount
      notify_about_referrral_bonus
    end

    private
    def notify_contractor
      template = <<-EOL
        You have requested to release funds for #{@milestone_path}.
        You will be notified when the funds have been released.
      EOL
      send_admin_message "Milestone Funding Release", template, @seller_id
    end

    def notify_about_referrral_bonus
      template = <<-EOL
        Congratulations! You have recieved $10 as a referral bonus, by inviting #{@buyer.full_name}.
      EOL
      send_admin_message "Congratulations! for Referral Bonus", template, @referral.id
    end

    def admin_percentage(request)
      amount = request.amount
      bed_fee = request.seller.membership_plan.service_fee.to_f || AdminSetting.first.try(:bid_fee)
      bed_fee = 5 unless bed_fee
      amount = amount.to_f - (bed_fee*amount.to_f/100)
      return amount
    end
  end
end