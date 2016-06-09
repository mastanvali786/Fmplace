class AccountingController < ApplicationController
  helper :authorize_net
  before_filter :authenticate_user!
  def make_payment
    @projects = current_user.projects.awardcomplete.order('updated_at DESC').page(params[:page]).per(PER_PAGE_COUNT)
  end

  def payment_list
    if current_user.buyer?
      @milestones = current_user.buyer_milestones.accepted
    else
      @milestones = current_user.seller_milestones.accepted
    end
    if params[:past_date] && params[:past_date].present?
     day_count = params[:past_date].to_i
     @milestones = @milestones.where(updated_at: (Time.now - day_count.days)..Time.now)
   end
   @milestones = @milestones.order('updated_at DESC')
   miles = []
   if params[:filter] == 'paid'
    @milestones.each do |mile|
      miles << mile if mile.paid?
    end
    @milestones = miles
  end
  if params[:filter] == 'unpaid'
    @milestones.each do |mile|
      miles << mile unless mile.paid?
    end
    @milestones = miles
  end
  @milestones = Kaminari.paginate_array(@milestones).page(params[:page]).per(MILESTONE_PER_COUNT)
end

def account_list
  @account_setting = current_user.account_setting
end

def save_account_settings
  @account_setting = current_user.account_setting
  if @account_setting.update_attributes(account_setting_params)
    redirect_to accounting_account_list_path
    flash[:notice] = "Now Default Payment Mode is #{@account_setting.payment_type.display_name}."
  else
    render "account_list"
    flash[:error] = "Please Select the option"
  end
end

def bank_details
  @account_setting = current_user.account_setting
  if @account_setting.update_attributes(account_detail_params)
    redirect_to accounting_account_list_path
    flash[:notice] = "Payment Settings has been saved successfully."
  else
    render "account_list"
    flash[:error] = "Please try again"
  end
end

def deposits
  @available_balance = current_user.balance.available
  if payment_method(current_user) == 'BRAINTREE'
    gon.client_token = generate_client_token
  end
    # if payment_method(current_user) == "PAYPAL"
    #   @available_balance = current_user.balance.available
    # else
    #   @available_balance = current_user.balance.payfast_available
    # end
  end

  def deposit
    if current_user
      if payment_method(current_user) == 'PAYFAST'
        return payfast_deposit
      elsif payment_method(current_user) == 'BRAINTREE'
        return braintree_deposit
      elsif payment_method(current_user) == 'AUTHORIZECREDITCARD'
        return authorize_credit_deposit
      elsif payment_method(current_user) == 'PAYPAL'
        amount = params[:amount]
        set_current_user
        current_user_set_paypal_ipn_settings  admin_withdrawal_requests_url
        balance = current_user.balance
        error_message = ""
        error = false
        amount = params[:amount].to_f
        request = balance.request_deposit amount
        invoice = request.invoice
        unless invoice.present?
          error = true
          error_message = "The system encountered an error.  Please contact appropriate persons."
        end
        if error
          render json: {error:true, message: error_msg}, status: :unprocessable_entity
        else
          render json: {success:true, invoiceUrl:deposit_invoice_path(invoice), payerViewUrl:invoice.pay_url, pay_method: "PAYPAL"}
        end
      else
        error = true
        error_message = "Please set your default payment method in #{view_context.link_to("Payment Setting", accounting_account_list_path)}"
        render json: {error:true, message: error_message}, status: :unprocessable_entity
      end
    else
      redirect_to :back
    end
  end

  def payfast_deposit
    
    if current_user
      amount = params[:amount]
      set_current_user
      current_user_set_paypal_ipn_settings  admin_withdrawal_requests_url
      balance = current_user.balance
      error_message = ""
      error = false
      amount = params[:amount].to_f
      request = balance.pay_fast_request_deposit amount
      invoice = request.invoice
      payment_settings = payfast_url(request)
      unless invoice.present?
        error = true
        error_message = "The system encountered an error.  Please contact appropriate persons."
      end
      if error
        render json: {error:true, message: error_message}, status: :unprocessable_entity
      else
        render json: {success:true, invoiceUrl:deposit_invoice_path(invoice), payerViewUrl:"", payment_settings: payment_settings, pay_method: "PAYFAST"}
      end
    else
      redirect_to :back
    end
    
    
  end

  def authorize_credit_deposit
    if current_user
      amount = params[:amount]
      set_current_user
      current_user_set_paypal_ipn_settings  admin_withdrawal_requests_url
      balance = current_user.balance
      error_message = ""
      error = false
      amount = params[:amount].to_f
      request = balance.authorize_credit_request_deposit amount
      invoice = request.invoice
      #payment_settings = authorize_credit_url(request)
      unless invoice.present?
        error = true
        error_message = "The system encountered an error.  Please contact appropriate persons."
      end
      if error
        render json: {error:true, message: error_message}, status: :unprocessable_entity
      else
        @deposit_request = request
        return render 'authorize_deposit'
        #render json: {success:true, invoiceUrl:deposit_invoice_path(invoice), payerViewUrl:"", payment_settings: '', pay_method: "AUTHORIZECREDITCARD"}
      end
    else
      redirect_to :back
    end
  end

  def withdraw
    if payment_method(current_user) == 'PAYFAST'
      error_message = "For Withdrawal Please select Paypal Payments."
      render json:{error:true, message:error_message}, status: :unprocessable_entity
    elsif payment_method(current_user) == 'BRAINTREE'
      error_message = "For Withdrawal Please select Paypal Payments."
      render json:{error:true, message:error_message}, status: :unprocessable_entity
    elsif payment_method(current_user) == 'AUTHORIZECREDITCARD'
      error_message = "For Withdrawal Please select Paypal Payments."
      render json:{error:true, message:error_message}, status: :unprocessable_entity
    elsif  payment_method(current_user) == 'PAYPAL'
      set_current_user
      current_user_set_paypal_ipn_settings  admin_withdrawal_requests_url
      balance = current_user.balance
      error_message = ""
      error = false
      amount = params[:amount].to_f
      unless balance.can_withdraw? amount
        error = true
        error_message = "Balance does not have enough funds."
      end
      unless balance.request_withdrawal amount
        error = true
        error_message = "System encountered a problem, please notify administrators."
      end unless error
      unless error
        available_balance = current_user.balance.available
        render json: {success:true,available:view_context.number_to_currency(available_balance), amount:view_context.number_to_currency(amount), withdrawals_url: view_context.link_to('here', withdrawal_requests_path)}
      else
        render json:{error:true, message:error_message}, status: :unprocessable_entity
      end
    else
      error = true
      error_message = "Please set your default payment method in #{view_context.link_to("Payment Setting", accounting_account_list_path)}"
      render json: {error:true, message: error_message}, status: :unprocessable_entity 
    end
  end

  def payfast_withdraw
    set_current_user
    balance = current_user.balance
    error_message = ""
    error = false
    amount = params[:amount].to_f
    unless balance.can_withdraw? amount
      error = true
      error_message = "Balance does not have enough funds."
    end
    unless balance.payfast_request_withdrawal amount
      error = true
      error_message = "System encountered a problem, please notify administrators."
    end unless error
    unless error
      available_balance = current_user.balance.available
      render json: {success:true,available:view_context.number_to_currency(available_balance), amount:view_context.number_to_currency(amount), withdrawals_url: view_context.link_to('here', withdrawal_requests_path)}
    else
      render json:{error:true, message:error_message}, status: :unprocessable_entity
    end
  end

  def transactions
    @transactions = Kaminari.paginate_array(current_user.payments.try(:reverse)).page(params[:page]).per(PER_PAGE_COUNT)
  end

  def withdrawals
    @accounts = current_user.account_setting
    @type = @accounts.withdraw
    @available_balance = current_user.balance.available
    # if payment_method(current_user) == "PAYPAL"
    #   @available_balance = current_user.balance.available
    # else
    #   @available_balance = current_user.balance.payfast_available
    # end
    @withdrawal_email = @accounts.paypal_email || current_user.email
  end

  def transaction_pdf
   @user = current_user
   @transactions = current_user.payments.try(:reverse)
   respond_to do |format|
    format.pdf do
      logo = get_logo
      pdf = TransactionPdf.new(@transactions, @user, view_context, logo) 
      send_data pdf.render, :filename => 'products.pdf', :type => 'application/pdf', :disposition => 'inline'
    end
  end
end

def payment_list_pdf
  if current_user.buyer?
    @milestones = current_user.buyer_milestones.accepted
  else
    @milestones = current_user.seller_milestones.accepted
  end
  miles = []
  url = request.fullpath
  day_count = 24 if url.include?("24") 
  day_count = 7  if url.include?("7")
  day_count = 14 if url.include?("14")
  day_count = 30 if url.include?("30")
  day_count = 60 if url.include?("60")
  day_count = 90 if url.include?("90")
  @milestones = @milestones.where(updated_at: (Time.now - day_count.days)..Time.now) if day_count.present?
  if url.include?("unpaid")
    @milestones.each do |mile|
      miles << mile unless mile.paid?
    end
    @milestones = miles
  elsif url.include?("paid")
    @milestones.each do |mile|
      miles << mile if mile.paid?
    end
    @milestones = miles
  end
  @user = current_user
  @milestones = @milestones.sort_by { |milestone| milestone.updated_at }.reverse!
  respond_to do |format|
    format.pdf do
      logo = get_logo
      pdf = PaymentListPdf.new(@milestones, @user, view_context, logo)
      pdf.stroke_color  'ff7808'
      send_data pdf.render, :filename => 'products.pdf', :type => 'application/pdf', :disposition => 'inline'
    end
  end
end

def save_account
  current_user.account_setting.update_attributes(account_params)
  redirect_to :back
end


def payfast_url(request)
  setting = request.user.account_setting
  merchant_id = setting.merchant_id
  merchant_key = setting.merchant_key
  values = {
    item_name: 'Deposit Fund',
    amount: request.amount,
    currency: 'ZAR',
    return_url: "#{CURRENT_URL_DEPOSIT}" ,
    cancel_url: "#{CURRENT_URL_DEPOSIT}",
    notify_url: "#{PAYFAST_IPN_DEPOSIT}",
    custom_str1: "Deposit",
    custom_int1: request.id,
    merchant_id: PaymentType.payfast_merchant_id,
    merchant_key: PaymentType.payfast_merchant_key
  } 
  PaymentType.payfast_mode_url + "?" + values.to_query  
end

def authorize_credit_url(request)
  @sim_transaction = AuthorizeNet::SIM::Transaction.new(PaymentType.authorize_api_login_id, PaymentType.authorize_api_transaction_key, request.amount, :hosted_payment_form => true)
  @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => ipn_authorize_credit_deposit_url(:only_path => false)))  
  sim_fields(@sim_transaction)
  values = {
    item_name: 'Deposit Fund',
    amount: request.amount,
    currency: 'USD',
    x_invoice_num: 1 ,
    x_cust_id: 10
  }
  PaymentType.authorize_mode_url + "?" + values.to_query  
end


private
def skip_render? section
  %w(withdraw).include? section
end

def account_params
  params.require(:account_setting).permit(:withdraw,:user_id, :paypal_email)
end

def account_setting_params
  params.require(:account_setting).permit(:payment_type_id)
end

def account_detail_params
  params.require(:account_setting).permit(:paypal_email, :payfast_email, :merchant_id, :merchant_key)
end

def render_section
  @section = params[:action]
  unless skip_render? @section
    send @section
    render :show
  end
end

end
