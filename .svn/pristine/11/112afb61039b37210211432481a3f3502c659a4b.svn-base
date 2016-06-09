class UserMembershipPlan < ActiveRecord::Base

	belongs_to :user
	belongs_to :membership_plan

	def check_expiry
		if expire_date
			date_time = expire_date.in_time_zone(user.try(:time_zone)).strftime("%e %b %Y")
			start_date = DateTime.strptime(date_time, "%e %b %Y")
		    start_date == DateTime.now.strftime("%e %b %Y")
		end	
	end

	def self.automatic_membership_renewal
		all.each do |plan|
			user = plan.user
			membership_plan = plan.membership_plan
			date_time = plan.expire_date.in_time_zone(user.try(:time_zone)).strftime("%e %b %Y")
			plan_expiry_date = DateTime.strptime(date_time, "%e %b %Y")
			if plan_expiry_date == DateTime.now.strftime("%e %b %Y") && plan.auto_renewal == true
				balance = user.balance
				if user.balance.amount >= membership_plan.amount
					detected_amount = balance.amount - membership_plan.amount
					if balance.update_attributes(:amount => detected_amount)
						@payment = Payment.create(to: user.id, type: 'Debit', klass: 'Membership Upgrade', amount: membership_plan.amount, approvedOn: Time.now, approved: true, approvedBy: -1,)
		        		@payment.feature_transaction
		        	end
		        	UserMailer.send_about_membership_auto_renewal(user).deliver
				else
					basic_plan = MembershipPlan.find_by_name("Silver")
					current_plan = user.user_membership_plan
					if current_plan
						if current_plan.update_attributes(membership_plan_id: basic_plan.id, start_date: Date.today, expire_date: Date.today + 1.month, auto_renewal: true)
							@payment = Payment.create(to: user.id, type: 'Debit', klass: 'Membership Downgrade', amount: basic_plan.amount, approvedOn: Time.now, approved: true, approvedBy: -1,)
		        			@payment.feature_transaction
		        		end
						user.update_attributes(total_connects: user.total_connects + basic_plan.connects.to_i)
					end
					UserMailer.send_about_membership_degradation_renewal(user).deliver
				end
			elsif plan_expiry_date == (DateTime.now - 2.days).strftime("%e %b %Y")
				UserMailer.send_about_membership_expiry(user).deliver
			end
		end
	end
end
