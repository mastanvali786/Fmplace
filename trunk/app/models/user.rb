class User < ActiveRecord::Base
  include ApplicationHelper
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  include Messageables::User
  serialize :category_ids, Array
  devise :database_authenticatable, :registerable,:confirmable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :linkedin]
  validates :email, :presence => true
  mount_uploader :profile_photo, AvatarUploader
  has_many :advertisements
  has_many :projects
  has_one  :account_setting, dependent: :destroy
  has_many :post_messages
  has_many :attachments
  has_many :bids
  has_many :payments, foreign_key: :to
  has_many :post_messages
  has_many :project_sellers
  has_many :user_messages
  has_many :withdrawal_requests
  has_many :messages, through: :user_messages
  has_many :disputes
  has_many :report_violations
  has_many :deposit_requests
  has_many :feedbacks, foreign_key: "to_id"
  has_many :deposit_invoices, class_name: 'DepositInvoice', foreign_key: "sender_id"
  has_many :buyer_milestones, class_name: 'Milestone', foreign_key: "buyer_id"
  has_many :seller_milestones, class_name: 'Milestone', foreign_key: "seller_id"
  has_many :guest_users
  has_many :milestone_creater , class_name: 'Milestone', foreign_key: 'created_by'
  has_many :user_experiences
  has_many :user_educations
  has_one :user_biography
  has_one :domain_expertise
  has_one :user_skill
  has_one :user_membership_plan
  has_one :membership_plan, through: :user_membership_plan
  has_many :team_members, class_name: "User",foreign_key: "user_id"
  belongs_to :referral, class_name: "User", foreign_key: "ref_id"
  has_many :rehired_projects, class_name: "Project", foreign_key: "rehired_freelancer"
  belongs_to :role
  scope :sellers, -> { where(role_id: 1) }
  scope :active_sellers,-> { where(role_id: 1, approved: true) }
  scope :buyers, ->  { where(role_id: 2) }
  scope :freelancers, -> { where(role_id: 1) }
  scope :clients, ->  { where(role_id: 2) }
  scope :approved_shops, ->  { where(role_id: 1,approved: true) }
  scope :pending_shops, ->  { where(role_id: 1,approved: false) }
  scope :confirmed, ->  { where("confirmed_at IS NOT NULL") }
  scope :referral_members, -> { where("ref_id IS NOT NULL")}
  attr_accessor :ipn_settings
  after_create :update_account_settings
  before_create :check_user_count
  has_one :balance

  # Delegates
  delegate :name, :to => :membership_plan, prefix: true, allow_nil: true
  delegate :name, :to => :role, prefix: true, allow_nil: true
  delegate :full_name, to: :referral, prefix: true, allow_nil: true
  delegate :amount, :to => :balance, prefix: true, allow_nil: true


  SYS_ADMIN = OpenStruct.new name: "System Admin", id:-1, email: ""

  def update_account_settings
    self.account_setting = AccountSetting.create(paypal_email:self.email)
    self.save
  end


  # Odef self.from_omniauth(auth, role)
  def self.from_omniauth(auth, role)
    if user = User.where(:email => auth["info"]["email"]).first
      user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name # assuming the user model has a name
            # user.profile_photo = auth.info.image
        user.role_id = role["role_id"]
        user.skip_confirmation!
          end
        end
      end

      def self.new_with_session(params, session)
        super.tap do |user|
          if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
            user.email = data["email"] if user.email.blank?
          end
        end
      end

      def active_for_authentication?
    #remember to call the super
    #then put our own check to determine "active" state using
    #our own "is_active" column
    super and self.is_active?
  end

  def inactive_message
    unless self.confirmed_at?
      "Please confirm your email address to login. Didn't receive confirmation instructions? <a href='/users/confirmation/new'>Click</a> to resend confirmation."
    else
      "Sorry, this account has been deactivated. Please contact Admin at #{admin_email}"
    end
  end

  def self.automatic_withdrawal
    sellers.each do |usr|
      if usr.account_setting && usr.account_setting.withdraw.eql?(1)
        balance = usr.balance
        amt = usr.balance.available
        if amt > 0
          if balance.can_withdraw? amt
            request = PayPalWithdrawalRequest.create! amount:amt, balance_id:balance.id, user_id:usr.id, withdraw_type:'Auto'
          end
          if request
            invoice = request.invoice
            PayPalMerchantSdk.doMassPayment(request, invoice)
          end
        end
      end
    end
  end

  def check_membership_mail
    sellers.each do |seller|
      if seller.user_membership_plan
        plan = seller.user_membership_plan
        expiry_date = plan.expire_date
        difference = (expiry_date.to_datetime - Date.today.to_datetime).to_i
        if difference && difference == 3
          UserMailer.send_membership_upgrade_mail(self).deliver
        end
      end
    end
  end

  def visible_name
    if buyer?
      full_name
    else
      display_name ||  full_name
    end
  end

  def paypal_email
    self.account_setting.paypal_email || self.email
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    first_name || full_name
  end

  def buyer?
    role_id.eql?(2)
  end

  def seller?
    role_id.eql?(1)
  end

  def referrals
    User.where(ref_id: self.id)
  end

  def remaining_connects
    total_connects - used_connects
  end

  # Membership Plan Bids Count
  def bids_count_plan
    if seller?
      expiry_date = user_membership_plan.expire_date
      start_date = user_membership_plan.start_date
      bids.where(updated_at: start_date..expiry_date).try(:count)
    end
  end

  # 12 months back data for user

  def total_bids_m
    if buyer?
      projects.where("updated_at >' Time.now - 12.months'").try(:count)
    else
      bids.where("updated_at >' Time.now - 12.months'").try(:count)
    end
  end

  def total_awards_m
    if buyer?
     working = projects.where("updated_at >' Time.now - 12.months'").map(&:current_state).count('awarded')
     complete = projects.where("updated_at >' Time.now - 12.months'").map(&:current_state).count('completed')
     complete + working
   else
    project_sellers.where("updated_at >' Time.now - 12.months'").count
  end
end
def total_awards_ratio_m
  (total_awards_m*100)/total_bids_m if total_bids_m >= 1
end

def earnings_per_client_m
  if total_awards_m >=1
    ern =  earnings/total_awards_m
    ern ? ern.round(2) : 0
  else
    0
  end
end

# life time data on overhaulbids

def total_bids
  if buyer?
    projects.count
  else
    bids.count
  end
end

def total_awards
  if buyer?
    working = projects.map(&:current_state).count('awarded')
    complete = projects.map(&:current_state).count('completed')
    complete + working
  else
    project_sellers.count
  end
end

def total_awards_ratio
  (total_awards*100)/total_bids if total_bids >= 1
end

def earnings
  b = balance.try(:total) - deposited_amount
  b ? b.round(2) : 0
end

def earnings_per_client
  if total_awards >=1
    ern =  earnings/total_awards
    ern ? ern.round(2) : 0
  else
    0
  end
end

def deposited_amount
  amount = 0
  if self
    deposit_invoices.each do |invoice|
      amount = amount + invoice.amount.to_f if invoice.paid?
    end
  end
  amount
end

def user_project?(projects_id = 0)
  projects.where(id: projects_id).present?
end

def canbid?(project)
  return false if buyer?
  if project.current_state == 'opened' && approved
    return true
  else
    return false
  end
end

def can_do_feature_bid?
  balance.available >= 10
end

def can_upgrade_plan?
 balance.available >= 20
end

def awared_projects
end

def skills
  get_name_by_ids(SkillTag, user_skill.known_skills) if user_skill && user_skill.known_skills
end

def biography_summary
  user_biography.try(:summary)
end

def recommended
  if feedbacks.approved.count > 0
    feedbacks.approved.average(:aggregate)*10
  else
    0
  end
end

def review
  feedbacks.approved.count
end

def ratings
  count  = feedbacks.approved.count
  if count > 0
    quality = feedbacks.approved.sum(:quality_work)
    response = feedbacks.approved.sum(:responsiveness)
    profession = feedbacks.approved.sum(:professionalism)
    expert = feedbacks.approved.sum(:expertise)
    costs = feedbacks.approved.sum(:cost)
    schedules = feedbacks.approved.sum(:schedule)
    sum = quality + response + profession + expert + costs + schedules
    avg = (sum / 6.0).round(1)
    avg = (avg / count).round(1)
  else
    0
  end
end

def self.current
  Thread.current[:user]
end

def self.current=(user)
  Thread.current[:user] = user
end

def self.sys_admin
  SYS_ADMIN
end

def self.sys_admin?(user_id)
  user_id == sys_admin.id
end

def profile_photo_url
  return "#{SITE_NAME}#{profile_photo.url}" if profile_photo.url.present?
  "#{SITE_NAME}/assets/nophoto2.gif"
end

def balance
  Balance.for_user self.id
end

def project_bid(project_id)
  bids.active_bids.where(project_id: project_id).first
end

def is_bidded?(projects_id)
end

def full_state
  State.where(state_code: state).try(:first).try(:state_name)
end

def has_bid(project)
  bids.map(&:project_id).include? project.id
end

def has_project(project)
  if  project.seller && project.project_seller
    self.id == project.seller.try(:id) && project.project_seller.try(:bid).try(:accepted?)
  else
    false
  end
end

def full_location
  loc_name = "#{country_name}" if country_name
  loc_name += " , #{state_name}" if state_name
  loc_name += " , #{city}" if city
  return loc_name
end

# for buyer & seller

def project_posted_bidded
  if buyer?
    projects.try(:count)
  else
    bids.try(:count)
  end
end

# Current membership plan
def current_plan
  membership_plan
end

def project_awarded
  if buyer?
    projects.in_state(:awarded).try(:count)
  else
    project_sellers.map(&:project).compact.map(&:current_state).count('awarded')
  end
end

def project_completed
  if buyer?
    projects.in_state(:complete).try(:count)
  else
    project_sellers.map(&:project).compact.map(&:current_state).count('completed')
  end
end

def paid_amount
  if buyer?
    payments.credits.sum(:amount)
  else
    earnings
  end
end

def pending_amount
  if buyer?
    milestone_creater.accepted.sum(:price) - payments.credits.sum(:amount)
  else
    b = balance.try(:available) + withdrawal_pending
    b.round(2) if b
  end
end

def withdrawal_pending
  withdrawal_requests.try(:pending).sum(:amount)
end

def withdrawal_completed
  withdrawal_requests.try(:completed).sum(:amount)
end

def message_count
  messages.inbox.unread.count
end

def role_name
 return "Freelancer" if role_id.eql?(1)
 return "Client" if role_id.eql?(2)
end

def public_url
  "#{SITE_URL}/account/user_public_profile?id=#{self.id}"
end

  # devise confirm! method overriden
  def confirm!
    super
    welcome_message
    if seller? && self.ref_id.present?
      reference_connect = User.find_by_id(self.ref_id)
      reference_connect.update_attributes(bonus_connects: reference_connect.bonus_connects + 10)
      subject = "Congratulations! for Referral Bonus Connects"
      body = "Congratulations! You have recieved 10 connects as a referral bonus."
      message = Message.normal_message from:"System Admin", created_by:-1, subject: subject, body:body, to:reference_connect.id
      message.save!
    end
  end

  def country_name
    Country.find_by_id(country_id).try(:name) if country_id
  end

  def state_name
    State.find_by_id(state_id).try(:state_name) if state_id
  end

  def user_projects_count
    if buyer?
      projects.try(:count)
    else
      project_sellers.try(:count)
    end
  end

  def has_payment_info?
    braintree_customer_id
  end

  def my_projects_count
    if buyer?
      projects.count
    else
      pids = bids.active.map(&:project_id)
      projects = Project.where(id: pids) if pids
      projects ? projects.count : 0
    end
  end

  def all_open_projects_count
   Project.all.map(&:current_state).count('opened')
 end

 def membership_plan_create
    user = self
    membership_plan = MembershipPlan.first
    if user.seller?
      user.update_attributes(total_connects: membership_plan.connects.to_i)
      plan = UserMembershipPlan.new(user_id: user.id ,membership_plan_id: membership_plan.id, start_date: user.created_at, expire_date: user.created_at.to_date + 1.months)
      plan.save!
    end
  end


 private

 def welcome_message
   emailtemplate=EmailTemplate.find_by_template('welcome_to_reverse_auction')
   subject=emailtemplate.subject
   body=emailtemplate.content % {url: SITE_NAME, first_name: self.first_name, email: self.email,signin_url:SITE_LOGIN_URL,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
   email_setting(self,subject,body,self.email)
   # UserMailer.delay.welcome_email(self)

 end

 def check_user_count
  if  User.count >= USER_COUNT
    mail = UserMailer.user_limit_crossed
    custom_smtp_settings = {:enable_starttls_auto => true,
      :address => "smtp.gmail.com",
      :port => 587,
      :domain => "gmail.com",
      :authentication => 'plain',
      :user_name => "auctionsoftwares@gmail.com",
      :password => "auction!@#"}
      mail.delivery_method.settings.merge! custom_smtp_settings
      mail.deliver
      return false
    else
      return true
    end
  end
end