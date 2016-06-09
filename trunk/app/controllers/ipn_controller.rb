class IpnController < ApplicationController
	def paypal
		if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
			PayPalIpn.process params
			Rails.logger.info "It is comming back here"
			render :text => "VERIFIED"
		else
			render :text => "INVALID"
		end
	end

	def payfast
		Rails.logger.info params
		if params[:payment_status] == "COMPLETE"
			MilestoneInvoice.milestone_fund_status(params)
			render :text => "SUCCESSFUL"
		else
			render :text => "FAILED"
		end
	end

	def payfast_withdraw
		Rails.logger.info params
		if params[:payment_status] == "COMPLETE"
			WithdrawalRequest.pay_fast_withdraw_request(params)
			render :text => "SUCCESSFUL"
		else
			render :text => "FAILED"
		end
	end

	def payfast_deposit
		Rails.logger.info params
		if params[:payment_status] == "COMPLETE"
			DepositRequest.pay_fast_deposit_request(params)
			render :text => "SUCCESSFUL"
		else
			render :text => "FAILED"
		end
	end

	def authorize_credit
		if params[:x_response_reason_code] == "1"
			MilestoneInvoice.authorize_credit_milestone_fund_status(params)
	  end
	  redirect_to "/projects/action/payment?id=#{params[:x_project_id]}"
	end

	def authorize_credit_deposit
		if params[:x_response_reason_code] == "1"
			DepositRequest.authorize_credit_deposit_request(params)
		end
		redirect_to "/accounting/deposits"
	end
end
