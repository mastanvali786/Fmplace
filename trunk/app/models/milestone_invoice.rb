class MilestoneInvoice < ActiveRecord::Base
  include Messageable
  include BidsHelper
  include ApplicationHelper
  belongs_to :funding_request, class_name: "MilestoneFundingRequest", foreign_key: "milestone_funding_request_id"
  has_one :milestone, through: :funding_request
  belongs_to :receiver, class_name:"User", foreign_key: "receiver_id"
  belongs_to :sender, class_name:"User", foreign_key: "sender_id"
  validates :sender_id, :receiver_id, :amount, :type, presence:true

  def payer?(user)
    receiver == user
  end

  def paid!(transaction_id)
    set_transaction_id transaction_id
    mark_paid!
    funded!
  end

  def self.user_time_zone(user, date_time)
    if date_time
      date_time.in_time_zone(user.try(:time_zone)).strftime("%e %b %Y, %I:%M %p")
    end
  end

  def funded!
    if valid_funded
      update_attributes(funded:true)
      MilestoneInvoice.send_emails_payment_success(milestone)
      broadcast('milestone_invoice_funded', self)
    else
      MilestoneInvoice.send_emails_payment_failure
    end
  end

  def self.send_emails_payment_success(milestone)
    emailtemplate=EmailTemplate.find_by_template('funds_on_the_way')
    @delivery_date = MilestoneInvoice.user_time_zone(milestone.project.seller, milestone.delivery_date)
    @bed_fee = AdminSetting.first.try(:bid_fee)
    @bed_fee = 5 unless @bed_fee
    @amount_earned  = (milestone.price.to_f - (@bed_fee*milestone.price.to_f/100))
    @overhaul_fee = (@bed_fee*milestone.price.to_f/100)
    subject=emailtemplate.subject
    body=emailtemplate.content % {seller_visible_name: milestone.project.seller.visible_name,visible_name: milestone.project.seller.visible_name,full_title: milestone.project.full_title, price: milestone.price,site_name: SITE_NAME ,description: milestone.description,delivery_date: @delivery_date,bed_fee: @bed_fee,amount_earned: @amount_earned,overhaul_fee: @overhaul_fee, site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    EmailData.email_setting(User.current,subject,body,milestone.project.seller.email)
      #OverhaulMailer.delay.send_seller_funds_on_way(milestone.project, milestone)
      emailtemplate=EmailTemplate.find_by_template('payment_received')
      body=emailtemplate.content % {visible_name: milestone.project.buyer.visible_name, seller_visible_name: milestone.project.seller.visible_name,full_title: milestone.project.full_title, price: milestone.price,description: milestone.description,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
      subject=emailtemplate.subject
      EmailData.email_setting(User.current,subject,body,milestone.project.buyer.email)
      #OverhaulMailer.delay.notify_about_payment_success(milestone.project, milestone)
    end

    def send_emails_payment_failure
      emailtemplate=EmailTemplate.find_by_template('payment_failed')
      subject=emailtemplate.subject
      body=emailtemplate.content % {visible_name: milestone.project.buyer.visible_name, full_title: milestone.project.full_title, price: milestone.price,description: milestone.description,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
      EmailData.email_setting(User.current,subject,body,milestone.project.buyer.email)
     # OverhaulMailer.delay.notify_about_payment_fail(milestone.project, milestone)
   end

   def self.milestone_fund_status(params)
    milestone_invoice = MilestoneInvoice.find_by_id(params[:custom_int1])
    if milestone_invoice.present?
      milestone_invoice.update_attributes(funded: true, paidOn: Time.now, transaction_id: params[:pf_payment_id])
      funding_request_update = milestone_invoice.funding_request.update_attributes(sent_at: Time.now)
      reciever_balace = milestone_invoice.receiver.balance
      amoutn_gross = params[:x_amount] || params[:amount_gross]
      total_amount = reciever_balace.amount.to_s.to_d + amoutn_gross.to_s.to_d
      reciever_balace.update_attributes(amount: total_amount)
      MilestoneInvoice.send_emails_payment_success(milestone_invoice.milestone)
    end
  end


  def self.authorize_credit_milestone_fund_status(params)
    milestone_invoice = MilestoneInvoice.find_by_id(params[:x_invoice_num])
    if milestone_invoice.present?
      milestone_invoice.update_attributes(funded: true, paidOn: Time.now, transaction_id: params[:x_trans_id])
      funding_request_update = milestone_invoice.funding_request.update_attributes(sent_at: Time.now)
      reciever_balace = milestone_invoice.receiver.balance
      amoutn_gross = params[:x_amount] || params[:amount_gross]
      total_amount = reciever_balace.amount.to_s.to_d + amoutn_gross.to_s.to_d
      reciever_balace.update_attributes(amount: total_amount)
      MilestoneInvoice.send_emails_payment_success(milestone_invoice.milestone)
    end
  end

  def self.braintree_milestone_fund_status(params, invoice)
    milestone_invoice = MilestoneInvoice.find_by_id(invoice.id)
    if milestone_invoice.present?
      milestone_invoice.update_attributes(funded: true, paidOn: Time.now, transaction_id: params.transaction.id, data: params)
      funding_request_update = milestone_invoice.funding_request.update_attributes(sent_at: Time.now)
      reciever_balace = milestone_invoice.receiver.balance
      total_amount = reciever_balace.amount.to_s.to_d + params.transaction.amount.to_s.to_d
      reciever_balace.update_attributes(amount: total_amount)
      MilestoneInvoice.send_emails_payment_success(milestone_invoice.milestone)
    end
  end

  protected

  def mark_paid!
    raise "This method should be overriden to mark invoice as paid and set paid on date"
  end

  def valid_funded
    raise "This method should be overriden to check if invoice has in fact been funded"
  end

  private
  def set_transaction_id transaction_id
    update_column :transaction_id, transaction_id
  end
end