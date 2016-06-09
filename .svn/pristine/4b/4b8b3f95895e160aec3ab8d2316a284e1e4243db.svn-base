class WithdrawalsController < ApplicationController
	def requests
		@requests = current_user.withdrawal_requests.order("created_at DESC").page params[:page]
		set_back_url
	end
	def show
		@request = WithdrawalRequest.find params[:id]
	end
end
