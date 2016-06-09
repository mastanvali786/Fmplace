class Bid < ActiveRecord::Base
  include BidsHelper
  include ApplicationHelper
  belongs_to :user
  belongs_to :project
  has_many :bid_milestones
  has_many :attachments, class_name: "BidAttachment"
  has_one :project_seller
  has_many :report_violations
  validates :details, presence: true
  validates :estimated_days, presence: true
  validate :membership_plan, on: :create
  scope :active, ->   { where(withdrawn: false) }
  scope :active_bids, ->   { where(withdrawn: false, declined: false, hidden: false) }
  scope :declined_bids, -> { where(withdrawn: false, declined: true) }
  scope :hidden_bids, ->   { where(withdrawn: false, hidden: true) }
  attr_accessor :file_name 
  def milestones
    bid_milestones
  end

  #after_create :send_buyer_about_bid
  after_update :send_buyer_about_update_bid

  def featured?
    featured
  end

  def send_buyer_about_update_bid
    current_user = User.current=(user)
    bid = self
    project = self.project
    buyer_email = project.buyer.email
    if project.seller.present?
      seller_email = project.seller.email
    end
    if (bid.awarded == false && bid.declined == false && bid.accepted == false && bid.buyer_note.nil? == true)
      emailtemplate=EmailTemplate.find_by_template('send_buyer_update_bid')

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
    body=emailtemplate.content % {buyer_visible_name: project.buyer.visible_name,end_date: user_new_time_zone(project.buyer, project.end_date), details: bid.details, estimated_days: @estimates,proposed_amount: bid.proposed_amount,attachments: attachments,user_visible_name: bid.user.visible_name,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER,login_link: SITE_LOGIN_URL}
    subject=emailtemplate.subject % {full_title: project.full_title}
    email_setting(User.current,subject,body,buyer_email)
    #OverhaulMailer.delay.send_buyer_about_update_bid(bid,project,buyer_email)
  elsif (bid.awarded == true && bid.declined == false && bid.accepted == false && bid.buyer_note.nil? == true)
    emailtemplate=EmailTemplate.find_by_template('send_buyer_reward')
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
  body=emailtemplate.content % {buyer_visible_name: project.buyer.visible_name,full_title: project.full_title, details: bid.details, estimated_days: @estimates,proposed_amount: bid.proposed_amount,attachments: attachments,user_visible_name: bid.user.visible_name,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
  subject=emailtemplate.subject % {full_title: project.full_title}
  email_setting(User.current,subject,body,buyer_email)
    #OverhaulMailer.delay.send_buyer_about_award(bid,project,buyer_email)
    if project.seller.present?
     emailtemplate=EmailTemplate.find_by_template('send_seller_about_reward')
     @estimates=estimated_days_display bid.estimated_days
     body=emailtemplate.content % {user_visible_name: project.seller.visible_name, full_title: project.full_title, category_name: project.category_name,subcategory_name: project.subcategory_name,tags: project.tags,skills: project.skills,budget: project.budget,estimated_time: project.estimated_time,location: project.location,description: project.description,details: bid.details,estimated_days: @estimates,proposed_amount: bid.proposed_amount,how_it_work_link: HOW_IT_WORK,earned_amount: bid.earned_amount,site_logo:SITE_LOGO,workroom_url:project.workroom_url,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
     subject=emailtemplate.subject % {full_title: project.full_title}
     email_setting(User.current,subject,body,seller_email)
    #OverhaulMailer.delay.send_seller_about_award(bid,project,seller_email)
  end
elsif ( bid.awarded == true && bid.declined == false && bid.accepted == true && bid.accepted_date.nil? == true)
      #OverhaulMailer.delay.send_buyer_about_next_step(bid,project,buyer_email)
    end
  end

  private

  def membership_plan
    current_user = User.current=(user)
    if current_user.membership_plan.present?
      if current_user.used_connects >= current_user.total_connects && current_user.bonus_connects.zero? && current_user.user_membership_plan.check_expiry
        errors.add :base, 'Crossed your limit/Expired,pay to continue the service/Upgrade to higher plan/'
      elsif current_user.used_connects >= current_user.total_connects && current_user.bonus_connects.zero? || current_user.user_membership_plan.check_expiry
        errors.add :base, "Please upgrade your <a href=/memberships >Membership plan "
      end
    end
  end


end
