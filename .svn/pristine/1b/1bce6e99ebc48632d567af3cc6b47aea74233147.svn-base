class PaymentsController < ApplicationController
  
  def show
    @payment = Payment.find params[:id]
    @back = flash["_return"]
  end
end
