class DepositInvoicesController < ApplicationController

  before_filter :load_invoice, only: [:show]

  before_filter :load_back_url

  def index
    @invoices =  current_user.deposit_invoices.order('updated_at DESC').page(params[:page]).per(SHOPS_PER_COUNT)
  end

  private
  def load_invoice
    @invoice = DepositInvoice.find params[:id]
  end

  def load_back_url
    @back = flash["_return"]
  end
end
