class MilestonesController < ApplicationController
  before_filter :set_current_user
  before_filter :load_milestone, except: [:create, :popup_new]
  before_filter :modify_date_params, :only => [:create, :update]

  def create
    if params[:milestone] && params[:milestone][:project_id]
      @project = Project.find params[:milestone][:project_id]
      @buyer_id = @project.buyer.id
      @seller_id = @project.seller.id
    end
    @milestone = Milestone.new(milestone_params)
    if @milestone.save
      @message = "Milestone was created successfully."
    end
    render_popup
  end

  def popup_new
    @project = Project.find params[:project_id]
    @milestone = @project.milestones.new
    @buyer_id = @project.buyer.id
    @seller_id = @project.seller.id
    handle_popup
  end

  def popup
    @milestone = Milestone.find params[:id]
    @buyer_id = @milestone.project.buyer.id
    @seller_id = @milestone.project.seller.id
    handle_popup
  end

  def show
    @back = flash["_return"]
  end

  def request_fund
    if payment_method(current_user) == 'PAYFAST'
        return pay_fast_request_fund
    elsif payment_method(current_user) == 'BRAINTREE'
        return braintree_request_fund
    elsif payment_method(current_user) == 'AUTHORIZECREDITCARD'
      return authorize_credit_request_fund
    elsif payment_method(current_user) == 'PAYPAL'
      if @milestone.project.seller? current_user
        pay_set = milestone_payment_settings
        @milestone.update_attributes(:current_url=>"#{pay_set.current_url}",
          :paypal_ipn_url=>"#{pay_set.paypal_ipn_url}")
        @milestone.request_fund!
        render json: {success:true, milestone:@milestone.id}
      else
        render json: {error:true, message: "You are not authorized to perform this request"}, status: :unprocessable_entity
      end
    end
  end

  def braintree_request_fund
    if @milestone.project.seller? current_user
      @milestone.brain_tree_request_fund!
      render json: {success:true, milestone:@milestone.id,  pay_method: 'BRAINTREE'}
    else
      render json: {error:true, message: "You are not authorized to perform this request"}, status: :unprocessable_entity
    end
  end


  def pay_fast_request_fund
    if @milestone.project.seller? current_user
      pay_set = payfast_milestone_payment_settings
      @milestone.update_attributes(:current_url=>"#{pay_set.current_url}",
        :paypal_ipn_url=>"#{pay_set.paypal_ipn_url}")
      @milestone.payfast_request_fund!
      render json: {success:true, milestone:@milestone.id,  pay_method: 'PAYFAST'}
    else
      render json: {error:true, message: "You are not authorized to perform this request"}, status: :unprocessable_entity
    end
  end

  def authorize_credit_request_fund
    if @milestone.project.seller? current_user
      pay_set = payfast_milestone_payment_settings
      @milestone.update_attributes(:current_url=>"#{pay_set.current_url}",
        :paypal_ipn_url=>"#{pay_set.paypal_ipn_url}")
      @milestone.authorizecredit_request_fund!
      render json: {success:true, milestone:@milestone.id,  pay_method: 'PAYFAST'}
    else
      render json: {error:true, message: "You are not authorized to perform this request"}, status: :unprocessable_entity
    end
  end

  def fund
    if payment_method(current_user) == 'PAYFAST'
        return payfast_fund
    elsif payment_method(current_user) == 'BRAINTREE'
        return braintree_fund
    elsif payment_method(current_user) == 'AUTHORIZECREDITCARD'
      return authorize_credit_fund
    elsif payment_method(current_user) == 'PAYPAL'
      error = false
      if @milestone.project.buyer? current_user
        #@milestone.settings = milestone_payment_settings
        pay_set = milestone_payment_settings
        @milestone.update_attributes(:current_url=>"#{pay_set.current_url}",
          :paypal_ipn_url=>"#{pay_set.paypal_ipn_url}")
        invoice = @milestone.fund!
        unless invoice.present?
          error = true
          error_message = "The system encountered an error.  Please contact appropriate persons."
        end
      else
        error = true
        error_message = "You are not authorized to perform this request"
      end
      if error
        render json: {error:true, message: error_msg}, status: :unprocessable_entity
      else
        render json: {success:true, milestone:@milestone.id, invoiceUrl:milestone_invoice_path(invoice), payerViewUrl:invoice.payerViewUrl, pay_method: 'PAYPAL'}
      end
    else
      error = true
      error_message = "Please set your default payment method in #{view_context.link_to("Payment Setting", accounting_account_list_path)}"
      render json: {error:true, message: error_message}, status: :unprocessable_entity
    end
  end

  def payfast_fund
    error = false
    # if @milestone.funding_request.nil?
      if @milestone.project.buyer? current_user
        pay_set = payfast_milestone_payment_settings
        @milestone.update_attributes(:current_url=>"#{pay_set.current_url}",
            :paypal_ipn_url=>"#{pay_set.paypal_ipn_url}")
        #invoice = @milestone.payfast_fund!
        @milestone.payfast_fund!
        render json: {success:true}
      end
      #   unless invoice.present?
      #     error = true
      #     error_message = "The system encountered an error.  Please contact appropriate persons."
      #   end
      # else
      #   error = true
      #   error_message = "You are not authorized to perform this request"
      # end
      # if error
      #   render json: {error:true, message: error_message}, status: :unprocessable_entity
      # else
      #   render json: {success:true, milestone:@milestone.id, invoiceUrl:milestone_invoice_path(invoice), payerViewUrl:'', pay_method: 'PAYFAST'}
      # end
  end

  def braintree_fund
    error = false
    # if @milestone.funding_request.nil?
      if @milestone.project.buyer? current_user
        pay_set = payfast_milestone_payment_settings
        @milestone.update_attributes(:current_url=>"#{pay_set.current_url}",
            :paypal_ipn_url=>"#{pay_set.paypal_ipn_url}")
        @milestone.braintree_fund!
        render json: {success:true}
      end
      #   invoice = @milestone.braintree_fund!
      #   unless invoice.present?
      #     error = true
      #     error_message = "The system encountered an error.  Please contact appropriate persons."
      #   end
      # else
      #   error = true
      #   error_message = "You are not authorized to perform this request"
      # end
      # if error
      #   render json: {error:true, message: error_message}, status: :unprocessable_entity
      # else
      #   render json: {success:true, milestone:@milestone.id, invoiceUrl:milestone_invoice_path(invoice), payerViewUrl:'', pay_method: 'PAYFAST'}
      # end
  end

  def authorize_credit_fund
    error = false
    # if @milestone.funding_request.nil?
      if @milestone.project.buyer? current_user
        pay_set = authorize_milestone_payment_settings
        @milestone.update_attributes(:current_url=>"#{pay_set.current_url}",
            :paypal_ipn_url=>"#{pay_set.paypal_ipn_url}")
        @milestone.authorize_credit_fund!
        render json: {success:true}
      end
      #   invoice = @milestone.authorize_credit_fund!
      #   unless invoice.present?
      #     error = true
      #     error_message = "The system encountered an error.  Please contact appropriate persons."
      #   end
      # else
      #   error = true
      #   error_message = "You are not authorized to perform this request"
      # end
      # if error
      #   render json: {error:true, message: error_message}, status: :unprocessable_entity
      # else
      #   render json: {success:true, milestone:@milestone.id, invoiceUrl:milestone_invoice_path(invoice), payerViewUrl:'', pay_method: 'AUTHORIZECREDITCARD'}
      # end
  end

  def release_fund
    if @milestone.project.seller? current_user
      if @milestone.release_fund_request && @milestone.release_fund_request.declined_request?
        pay = []
        PaymentDetail.all.map{ |pd| pay << pd if pd.request_id == @milestone.release_fund_request.id }.compact
        pay.map(&:payment).each do |p|
          p.declined= false
          p.save
        end
        render json: {success:true, milestone:@milestone.id}
        return
      end
      @milestone.release_fund!
      render json: {success:true, milestone:@milestone.id}
    else
      render json: {error:true, message: "You are not authorized to perform this request"}, status: :unprocessable_entity
    end
  end

  def destroy
    @milestone.destroy
    redirect_to :back
  end

  def accepted
    update_status  "accepted"
  end

  def rejected
    update_status  "rejected"
  end

  def update
    if @milestone.pending?
      if @milestone.update_attributes milestone_params
        @message = "Milestone was updated successfully."
      end
    end
    render_popup
  end

  def post_messages
    @project.milestones.new(milestone_params)
    @project.save
    redirect_to :back
  end

  private
  def update_status(action)
    @milestone.send "#{action}!"
    if @milestone.save!
      flash[:notice] = "Milestone was #{action} successfully."
    end
    redirect_to :back
  end

  def load_project
    @project = Project.find(params[:project_id])
  end

  def milestone_params
    params.require(:milestone).permit(:description,:project_id,
     :delivery_date,:price,:note,
     :buyer_id, :seller_id)
  end

  def handle_popup
    @status = :ok
    render_popup
  end

  def load_milestone
    @milestone = Milestone.find(params[:id])
  end

  def back_url
    request.headers["Referer"]
  end

  def milestone_payment_settings
    OpenStruct.new({ current_url:back_url, paypal_ipn_url:ipn_paypal_url})
  end

  def payfast_milestone_payment_settings
    OpenStruct.new({ current_url:back_url, paypal_ipn_url:ipn_payfast_url})
  end

  def authorize_milestone_payment_settings
    OpenStruct.new({ current_url:back_url, paypal_ipn_url:ipn_payfast_url})
  end

  def render_popup
    content = render_to_string "popup", locals: {milestone:@milestone, message:@message}, layout: false
    js = {content:content}
    status = :ok
    unless @milestone.valid?
      status = :unprocessable_entity
      js[:errors] = true
    end
    render json: js, status: @status || status
  end

  def modify_date_params
    if params[:milestone][:delivery_date].present?
      date_time = params[:milestone][:delivery_date].in_time_zone(current_user.try(:time_zone))
      params[:milestone][:delivery_date] = date_time.in_time_zone('UTC')
    end
  end
end
