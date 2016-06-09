class ReferalProgramController < ApplicationController

	before_filter :authenticate_user!

	def referral_program
   		@country=Country.find_by_id(current_user.try(:country_id))
   		@state=current_user.state_name
	end

	def referral_account
   		@country=Country.find_by_id(current_user.try(:country_id))
   		@state=current_user.state_name
   		@referrals = current_user.referrals.confirmed
	end
	
end
