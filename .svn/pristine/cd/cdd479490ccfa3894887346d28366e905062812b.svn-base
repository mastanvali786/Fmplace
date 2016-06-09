class DepositsController < ApplicationController
	def requests
		@requests = current_user.deposit_requests.order("created_at DESC").page(params[:page]).per(MILESTONE_PER_COUNT)
		set_back_url
	end
	def show
		@request = DepositRequest.find params[:id]
	end
end
