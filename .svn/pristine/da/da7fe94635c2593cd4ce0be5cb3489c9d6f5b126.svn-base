class AdminController < ApplicationController
  def payments
    @payments = Payment.page(params[:page])
  end
  def withdrawal_requests
    @requests = WithdrawalRequest.order("created_at DESC").page(params[:page])
  end
  def approve_withdrawal
    set_current_user
    withdrawal = Withdrawal.find params[:id]
    if withdrawal.approve! current_user
      flash[:notice] = "The withdrawal has been processed successfully. " +
        "#{view_context.number_to_currency withdrawal.amount} has been transferred to the receiver's balance."
    else
      flash[:error] = "Failed to approve withdrawal.  Please try again later or contact appropriate persons"
    end
    redirect_to :back
  end
  def approve_payment
    set_current_user
    payment = Payment.find params[:id]
    if payment.approve! current_user
      flash[:notice] = "The payment has been processed successfully. " +
        "#{view_context.number_to_currency payment.amount} has been #{payment.type.downcase}ed to the receiver's balance."
    else
      flash[:error] = "Failed to approve payment.  Please try again later or contact appropriate persons"
    end
    redirect_to :back
  end
end
