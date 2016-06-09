class MilestoneInvoicesController < ApplicationController

  before_filter :load_invoice, only: [:show, :funded]

  before_filter :load_back_url

  before_filter :get_tonen_for_braintree

  def get_tonen_for_braintree
    if payment_method(current_user) == 'BRAINTREE'
      gon.client_token = generate_client_token
    end
  end

  def index
    @invoices = MilestoneInvoice.all.order('updated_at DESC').page(params[:page]).per(PER_PAGE_COUNT)
  end
  def funded
    if @invoice.funded!
      flash[:notice] = "The invoice has been marked as funded successfully."
    else
      flash[:error] = "An error occured, failed to mark invoice as funded.<br/>Visit the Fund Invoice link to make sure you have already paid the invoice."
    end
    redirect_to :back
  end
  private
  def load_invoice
    @invoice = MilestoneInvoice.find params[:id]
  end

  def load_back_url
    @back = flash["_return"]
  end
end
