class TransactionsController < ApplicationController
	before_action :authenticate_user!
	def edit
		@credit_card = current_user.default_credit_card
		@tr_data = edit_customer_tr_data
	end


	def create
		project  = Project.find_by_id(params[:project_id])
		if params[:payment_type] == 'MILESTONE_FUND'
		  @invoice = MilestoneInvoice.find_by_id(params[:invoice_id])
		elsif params[:payment_type] == 'DEPOSIT_FUND'
			invoice, error = braintree_deposit(params)
			@invoice = invoice unless error
		elsif  params[:payment_type] == 'INVOICE_FUND'
			@invoice = MilestoneInvoice.find_by_id(params[:invoice_id])
		end
		@result = do_purchase(@invoice) if @invoice
		if @result && @result.success?
			current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
			if params[:payment_type] == 'MILESTONE_FUND'
		    MilestoneInvoice.braintree_milestone_fund_status(@result,@invoice)
		    redirect_to "/projects/action/payment?id=#{project.id}", notice: "Congraulations! Your transaction has been completed successfully!"
		  elsif params[:payment_type] == 'DEPOSIT_FUND'
		  	DepositRequest.braintree_deposit_request(@result,@invoice)
		  	redirect_to "/accounting/deposits", notice: "Congraulations! Your transaction has been completed successfully!"
		  elsif params[:payment_type] == 'INVOICE_FUND'
		  	 MilestoneInvoice.braintree_milestone_fund_status(@result,@invoice)
		  	redirect_to "/milestones/invoices", notice: "Congraulations! Your transaction has been completed successfully!"
		  end
		else
			flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
			gon.client_token = generate_client_token
			if params[:payment_type] == 'MILESTONE_FUND'
			  redirect_to "/projects/action/payment?id=#{project.id}"
		  elsif params[:payment_type] == 'INVOICE_FUND'
			  redirect_to "/milestones/invoices"
			 else
			 	redirect_to "/accounting/deposits"
		  end
		end
	end

	def do_purchase(invoice)
		unless current_user.has_payment_info?
			@result = Braintree::Transaction.sale(
				amount: invoice.amount,
				payment_method_nonce: params[:payment_method_nonce],
				customer: {
					first_name: params[:first_name],
					last_name: params[:last_name],
					email: current_user.email,
					phone: params[:phone]
					},
					options: {
						store_in_vault: true
						})
		else
			@result = Braintree::Transaction.sale(
				amount: invoice.amount,
				payment_method_nonce: params[:payment_method_nonce])
		end
		@result
	end

end
