class BidsController < ApplicationController
  before_filter :authenticate_user!
  include BidsHelper
  def create
    if params[:bid][:featured].eql?('1')
     @result = check_feature_proposal
     unless @result
       render json: {data: false}
       return
     end
   end
   @bid = Bid.new bid_params
   callback =  lambda do |bid|
    Bid.transaction do
      if bid.save
        bid.update_attribute :payment_id, @payment.id if @result
        add_attachments bid
        update_milestones bid
        update_bid_count bid
        send_buyer_about_bid(bid)
      end
    end
  end
  _update_bid  callback, :created
end

def send_buyer_about_bid(bid)
    project = bid.project
    buyer_email = project.buyer.email
    emailtemplate=EmailTemplate.find_by_template('send_buyer_bid')
    attachments=''
    if bid.attachments.present?
     bid.attachments.each do |attachment|
      attachments+="<li>
      <a href=#{SITE_URL}#{attachment.url} style=font-size:1em >
      #{attachment.name }
      </a>
      </li>"
    end
  else
    attachments="<li>None</li>"
  end 
  @estimates=estimated_days_display bid.estimated_days
  body=emailtemplate.content % {buyer_visible_name: project.buyer.visible_name, details: bid.details, estimated_days: @estimates,end_date: user_new_time_zone(project.buyer, project.end_date),proposed_amount: bid.proposed_amount,attachments: attachments,user_visible_name: bid.user.visible_name,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER,login_link:SITE_LOGIN_URL}
  subject=emailtemplate.subject % {full_title: project.full_title}
  email_setting(current_user,subject,body,buyer_email)
    #OverhaulMailer.delay.send_buyer_about_bid(bid,project,buyer_email)
  end

  def check_feature_proposal
    if @bid && @bid.payment_id
      return true
    end
    balance = current_user.balance
    if balance.can_withdraw?(feature_proposal_price)
      balance.amount = balance.amount - feature_proposal_price
      balance.save
      if balance
        @payment = Payment.create(to: current_user.id, type: 'Debit', klass: 'FeatureProposal', amount: feature_proposal_price,
         approvedOn: Time.now, approved: true, approvedBy: -1,)
        @payment.feature_transaction
        @payment ? true : false
      end
    else
      false
    end
  end

  def add_attachments(bid)
    if params[:attachments]
      params[:attachments].each do |attachment_data|
        if attachment_data.present?
          attachment = bid.attachments.new attachment:attachment_data
          attachment.save!
        end
      end
    end
  end

  # Increment and Decrement of Bids to the respective user
  def update_bid_count(bid)
    if (bid.user.used_connects >= bid.user.total_connects) 
      unless bid.user.bonus_connects.zero?
        bid.user.decrement!(:bonus_connects)
      end
    else
      bid.user.increment!(:used_connects)
    end
  end

  def update_bid_count_withdraw(bid)
    if bid.user.used_connects == bid.user.total_connects
      unless bid.user.bonus_connects.zero?
        bid.user.increment!(:bonus_connects)
      end
    else
      bid.user.decrement!(:used_connects) unless bid.user.used_connects.zero?
    end
  end

  def update
    @bid = Bid.find params[:id]
    if params[:bid][:featured].eql?('1') && !@bid.featured?
      @result = check_feature_proposal
      unless @result
        render json: {data: false}
        return
      end
    end
    callback =  lambda do |bid|
      Bid.transaction do
        if bid.update_attributes(bid_params)
          add_attachments bid
          update_milestones bid
        end
      end
    end
    _update_bid callback, :ok
  end

  def show
    @bid = Bid.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        logo = get_logo
        pdf = BidPdf.new(@bid, view_context, logo)       
        send_data pdf.render, filename: "info.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def withdraw
    bid = Bid.find params[:id]
    if bid.project.current_state == 'opened'
      bid.destroy
      update_bid_count_withdraw(bid)
      flash[:notice] = "Your proposal deleted successfully for this project."
    else
      flash[:error] = "This Project is already awarded. Can't withdrawn proposal now."
    end
    redirect_to :back
  end

  def edit
    @bid = Bid.find params[:id]
    @attachments = @bid.attachments
    template = render_to_string :edit, layout:false
    render json: {template:template}
  end

  def change_bid_status
    project = Project.find_by_id(params[:id])
    bid = project.project_seller.bid if project
    bid.update_attributes(change_bid_params) if bid
    bid.update_attribute :accepted_date, Time.now if params[:accepted] == 'true'
    if params[:declined] == 'true'
      @project = Project.find_by_id(params[:id])
      if @project.transition_to!(:opened)
        @project.project_seller.destroy if project.project_seller
        bid.awarded = false
        bid.hidden = false
        bid.declined_date = Time.now
        bid.save
      end
    end
    redirect_to :back
  end

  def hide_unhide_bid
    bid = Bid.find_by_id(params[:id])
    bid.update_attribute :hidden, params[:hidden] if bid
    if bid.hidden?
      msg = "Proposal submitted has been hidden successfully."
    else
      msg = "Unhidden bid from #{bid.user.full_name} successfully."
    end
    flash[:notice] = msg
    redirect_to :back
  end

  def decline_bid
    bid = Bid.find_by_id(params[:id])
    bid.update_attributes(declined: true, hidden: false) if bid
    flash[:notice] = "Declined bid from #{bid.user.full_name} successfully."
    redirect_to :back
  end

  def update_my_notes
    bid = Bid.find_by_id(params[:bid_id])
    if bid
      bid.update_attribute(:buyer_note,params[:bid][:buyer_note])
    end
    flash[:notice] = "My Note saved successfully."
    redirect_to :back
  end

  def send_report_violation
    @report = ReportViolation.new report_params
    if @report.save

      emailtemplate=EmailTemplate.find_by_template('send_violation_report')
      body=emailtemplate.content % {admin_name: admin_name, user_id: @report.user.id, full_name: @report.user.full_name,bid_user_id: @report.bid.user.id,bid_full_name: @report.bid.user.full_name,project_id: @report.project.id,site_url: SITE_URL,full_title: @report.project.full_title,description: @report.project.description,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
      subject=emailtemplate.subject
      email_setting(current_user,subject,body,admin_email)
      #ReportMailer.delay.send_violation_report(@report)
      flash[:notice] = "Violation Reported to Site Admin Successfully."
    else
      flash[:error] = "Failed To send Report Violation. Please try again."
    end
    redirect_to :back
  end

  private

  def change_bid_params
    params.permit(:accepted, :declined,:hidden)
  end

  def report_params
    params.permit(:bid_id, :project_id,:user_id, :subject, :body)
  end

  def bid_params
    params.require(:bid).permit!
  end

  def permitted_params
    [:subject, :body, :type]
  end

  def message_params
    params[:to] = params[:message][:to]
    params[:message].delete :to
    params.require(:message).permit(permitted_params)
  end

  def update_milestones(bid)
    if params[:milestones]
      params[:milestones].each do |key, milestone|
        milestone[:delivery_date] = Date.strptime(milestone[:delivery_date], '%m/%d/%Y')
        milestone = bid.bid_milestones.create(milestone)
        unless milestone.save
          bid.errors.add(:base, "Milestone: " + milestone.errors.full_messages.join(','))
          return false
        end
      end
    end
    return true
  end

  def _update_bid(update_func, status_success)
    project = Project.find_by_id(params[:bid][:project_id]) if params[:bid]
    if project && !project.current_state.eql?('opened')
      status = :unprocessable_entity
      js = {errors:"Project was already awarded/closed. You can't bid now."}
      render json: js, status: status
      return
    end
    if update_func.call(@bid)
      template = render_to_string :show, layout:false
      status = status_success
      js = {template:template}
    else
      status = :unprocessable_entity
      js = {errors:@bid.errors.full_messages.join('&nbsp;')}
    end
    render json: js, status: status
  end
end
