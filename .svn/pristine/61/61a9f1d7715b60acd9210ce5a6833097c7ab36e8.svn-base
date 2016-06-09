class Milestone < ActiveRecord::Base
  belongs_to :project
  include ApplicationHelper
  attr_accessor :settings
  validates :description, :status, :created_by, :project_id, :delivery_date, :price, presence: true
  validates_length_of :note, :maximum => 100
  scope :accepted, -> {where :status => :accepted}
  scope :pending, -> {where :status => :pending}
  scope :rejected, -> {where :status => :rejected}
  scope :funded , -> {where :status => :funded }
  has_one :funding_request, class_name: "MilestoneFundingRequest"
  has_one :release_fund_request, class_name: "MilestoneReleaseFundRequest"
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  belongs_to :buyer, class_name: "User", foreign_key: "buyer_id"
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"

  after_create :send_mail_about_milestone
  after_update :send_mail_about_milestone_update


  def send_mail_about_milestone_update
    milestone = self
    project = milestone.project
    creator_email = milestone.creator.email
    buyer_email = project.buyer.email
    seller_email = project.seller.email
    if (milestone.status == 'accepted' || milestone.status == 'rejected')             
      if (milestone.creator.role_name=='Client' && milestone.status == 'accepted')
         emailtemplate=EmailTemplate.find_by_template('buyer_milestone_accepted_status')
    elsif (milestone.creator.role_name=='Client' && milestone.status == 'rejected')
         emailtemplate=EmailTemplate.find_by_template('buyer_milestone_unaccepted_status')
     elsif (milestone.creator.role_name=='Freelancer' && milestone.status == 'accepted')
         emailtemplate=EmailTemplate.find_by_template('seller_milestone_accepted_status')
       elsif (milestone.creator.role_name=='Freelancer' && milestone.status == 'rejected')
         emailtemplate=EmailTemplate.find_by_template('seller_milestone_unaccepted_status')
     end
    body= emailtemplate.content % {buyer_visible_name: project.buyer.visible_name, seller_visible_name: project.seller.visible_name,full_title: project.full_title,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    subject=emailtemplate.subject % {status: milestone.status}
    email_setting(User.current,subject,body,buyer_email)
      #OverhaulMailer.delay.send_about_milestone_status(milestone,project,buyer_email)
    else
      if milestone.creator.role_name == "Buyer" 
        emailtemplate=EmailTemplate.find_by_template('buyer_milestone_update')
    subject=emailtemplate.subject
    body=emailtemplate.content % {seller_visible_name: project.seller.visible_name,full_title: project.full_title, price: milestone.price,description: milestone.description,delivery_date: milestone.delivery_date,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    else
      emailtemplate=EmailTemplate.find_by_template('seller_milestone_update')
     subject=emailtemplate.subject
    body=emailtemplate.content % {buyer_visible_name: project.buyer.visible_name,seller_display_name: project.seller.display_name,full_title: project.full_title, price: milestone.price,description: milestone.description,login_link: SITE_LOGIN_URL,creator_visible_name: milestone.creator.visible_name,delivery_date: milestone.delivery_date,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    end
    email_setting(User.current,subject,body,seller_email)
      #OverhaulMailer.delay.send_about_milestone_update(milestone,project,seller_email)
    end
  end

  def send_mail_about_milestone
    milestone = self
    project = milestone.project
    buyer_email = project.buyer.email
    seller_email = project.seller.email
    creator_email = milestone.creator.email
    if self.creator.role_name == "Seller"
        emailtemplate=EmailTemplate.find_by_template('buyer_milestone')
    
    body=emailtemplate.content % {buyer_visible_name: project.buyer.visible_name, seller_visible_name: project.seller.visible_name,full_title: project.full_title, price: milestone.price,description: milestone.description,delivery_date: milestone.delivery_date,login_link: SITE_LOGIN_URL,creator_visible_name: milestone.creator.visible_name,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
     subject=emailtemplate.subject
    email_setting(User.current,subject,body,buyer_email)
     # OverhaulMailer.delay.send_buyer_about_milestone(milestone,project,buyer_email)
    else
         emailtemplate=EmailTemplate.find_by_template('seller_milestone')
    
    body=emailtemplate.content % {seller_visible_name: project.seller.visible_name,full_title: project.full_title, price: milestone.price,description: milestone.description,delivery_date: milestone.delivery_date,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
     subject=emailtemplate.subject % {full_title: project.full_title}
    email_setting(User.current,subject,body,seller_email)
      #OverhaulMailer.delay.send_seller_about_milestone(milestone,project,seller_email)
    end
  end

  before_validation(on: :create) do
    current_user = User.current
    if current_user
      self.created_by ||= current_user.id
    end
  end

  def fund!
    request = request_fund  skip_broadcast:true
    settings = {current_url: self.current_url, paypal_ipn_url: self.paypal_ipn_url}
    invoice = request.invoice! User.current, settings
    request.broadcast_new_request
    invoice
  end

  def request_fund!
    request_fund
  end

  def payfast_request_fund!
    payfast_request_fund
  end

  def brain_tree_request_fund!
    braintree_request_fund
  end

  def authorizecredit_request_fund!
    authorize_credit_request_fund
  end

  def release_fund!
    buyer = project.buyer
    seller = project.seller
    amount = funding_request.invoice.amount
    MilestoneReleaseFundRequest.create! amount:amount, seller_id:seller.id, buyer_id:buyer.id, milestone_id:self.id
  end

  def release_fund_requested?
    release_fund_request.try("sent?")
  end

  def funding_requested?
    funding_request.try("sent?")
  end

  def funding_released?
    release_fund_request.try("released?")
  end
  
  def funded?
    funding_request.try("funded?")
  end

  def paid_at
    funding_request.try(:invoice).try(:paidOn)
  end

  def completed?
    if funding_request
      funding_request.try("funded?")
    else
      false
    end
  end

  def pending?
    status == "pending"
  end
  def accepted?
    status == "accepted"
  end
  def rejected?
    status == "rejected"
  end
  def accepted!
    self.status = "accepted"
  end
  def rejected!
    self.status = "rejected"
  end
  def owned_by?(user)
    created_by.blank? || created_by == user.id
  end

  def paid?
    release_fund_request.released if release_fund_request
  end

  def payment_status
    if paid?
      'Paid'
    elsif funded?
      'Funded'
    elsif release_fund_requested?
      'Release Request Sent'
    elsif funding_requested?  
      'Funding Request Sent'
    else
      'Pending'
    end
  end

  def shop_name
    project.project_seller.try(:user).try(:display_name)
  end

  def seller
    project.project_seller.try(:user)
  end

  def payment
    pay = []
    PaymentDetail.all.map{ |pd| pay << pd if pd.request_id == release_fund_request.try(:id) }
    pay = pay.first.try(:payment)
  end

  def url
    "/milestones/#{self.id}"
  end

  def project_shop
    "#{self.project.full_title} - #{self.shop_name}"
  end

  def project_buyer
    "#{self.project.full_title} - #{self.project.buyer.full_name}"
  end

  #Payfast Payments

  def payfast_fund!
    request = payfast_request_fund  skip_broadcast:true
    settings = {current_url: self.current_url, paypal_ipn_url: self.paypal_ipn_url}
    #invoice = request.invoice! User.current, settings
    request.broadcast_new_request
    #invoice
  end

  def braintree_fund!
    request = braintree_request_fund  skip_broadcast:true
    settings = {current_url: self.current_url, paypal_ipn_url: self.paypal_ipn_url}
    #invoice = request.invoice! User.current, settings
    request.broadcast_new_request
    #invoice
  end

  def authorize_credit_fund!
    request = authorize_credit_request_fund  skip_broadcast:true
    settings = {current_url: self.current_url, paypal_ipn_url: self.paypal_ipn_url}
    #invoice = request.invoice! User.current, settings
    request.broadcast_new_request
    #invoice
  end

  def payfast_amount
    self.price
    # funding_request.invoice.amount
  end

  def authorize_credit_amount
    self.price
  end

  private
  
  def request_fund(options={})
    defaults = { user_id:User.current.id, milestone_id:self.id }
    PayPalFundingRequest.create!(defaults.merge(options))
  end

  def payfast_request_fund(options={})
    defaults = { user_id:User.current.id, milestone_id:self.id }
    PayFastFundingRequest.create!(defaults.merge(options))
  end

  def braintree_request_fund(options={})
    defaults = { user_id:User.current.id, milestone_id:self.id }
    BrainTreeFundingRequest.create!(defaults.merge(options))
  end

  def authorize_credit_request_fund(options={})
    defaults = { user_id:User.current.id, milestone_id:self.id}
    AuthorizeCreditFundingRequest.create!(defaults.merge(options))
  end
end
