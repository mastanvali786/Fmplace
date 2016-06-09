class MembershipsController < ApplicationController

  def index
  	@membership_plan = MembershipPlan.all
  end

  def upgrade_plan
  	upgrade_plan = MembershipPlan.find(params[:plan_id])
  	plan_amount = upgrade_plan.amount
  	if upgrade_plan
  		current_plan = current_user.user_membership_plan
  		if current_plan
  			balance = current_user.balance
  			if balance.can_withdraw?(plan_amount)
  				balance.amount = balance.amount - plan_amount
  				balance.save
  				if balance
		        @payment = Payment.create(to: current_user.id, type: 'Debit', klass: 'Membership Upgrade', amount: plan_amount, approvedOn: Time.now, approved: true, approvedBy: -1,)
		        @payment.feature_transaction
		        @payment ? true : false
		      end
          if upgrade_plan.name == MembershipPlan.first.name
            if current_plan.update_attributes(membership_plan_id: upgrade_plan.id, start_date: Date.today, expire_date: Date.today + 12.years, auto_renewal: params[:auto_renewal])
              current_user.update_attributes(total_connects: current_user.total_connects + upgrade_plan.connects.to_i)
              redirect_to memberships_path
              flash[:notice] = "Successfully upgraded to basic membership plan"
              OverhaulMailer.delay.membership_upgraded(upgrade_plan, current_user)
            end
          else
  		      if current_plan.update_attributes(membership_plan_id: upgrade_plan.id, start_date: Date.today, expire_date: Date.today + 1.month, auto_renewal: params[:auto_renewal])
              current_user.update_attributes(total_connects: current_user.total_connects + upgrade_plan.connects.to_i, search_priority: true)
    					redirect_to memberships_path
    					flash[:notice] = "Successfully Upgraded to #{upgrade_plan.name} Membership Plan"
              OverhaulMailer.delay.membership_upgraded(upgrade_plan, current_user)
    				end
          end
  			else
  				redirect_to memberships_path
  				flash[:error] = "Please Check the balance in your account or try again later"
  			end
  		end
  	end
  end

  def current_status
    @membership = current_user.membership_plan
    @plan_details = current_user.user_membership_plan
  end
end