class OverhaulMailer < ActionMailer::Base
  default from: MAILER_FROM
  add_template_helper(BidsHelper)


  def admin_email
    AdminSetting.first.try(:email) || 'alan@overhaulbids.com'
  end
  
  def admin_name
    "#{AdminSetting.first.try(:first_name)} #{AdminSetting.first.try(:last_name)}" || 'Site Admin'
  end

  def user_time_zone(user, date_time)
    if date_time
      date_time.in_time_zone(user.try(:time_zone)).strftime("%e %b %Y, %I:%M %p")
    end
  end

  # send after bid submit
  def send_buyer_about_bid(bid,project,email)
  	@bid = bid
  	@project = project
    @login_link = SITE_LOGIN_URL
    @end_date = user_time_zone(@project.buyer, @project.end_date)
  	mail(to: email, subject: "Good News! Bid Received on #{@project.full_title}")
  end

  # send after when seller update bid
  def send_buyer_about_update_bid(bid,project,email)
  	@bid = bid
  	@project = project
    @login_link = SITE_LOGIN_URL
    @end_date = user_time_zone(@project.buyer, @project.end_date)
  	mail(to: email, subject: "Bid Updated on #{@project.full_title}")
  end

  #send after awarding project
  def send_buyer_about_award(bid,project,email)
  	@bid = bid
  	@project = project
    @login_link = SITE_LOGIN_URL
  	mail(to: email, subject: "Congratulations! You have Awarded #{@project.full_title}")
  end

  #send after awarding project
  def send_seller_about_award(bid,project,email)
  	@bid = bid
  	@project = project
    @how_it_work_link = HOW_IT_WORK
    @login_link = SITE_LOGIN_URL
  	mail(to: email, subject: "Congratulations! You were Awarded #{@project.full_title}")
  end

  def send_buyer_about_next_step(bid,project,email)
    @bid = bid
    @project = project
    @how_it_work_link = HOW_IT_WORK
    @login_link = SITE_LOGIN_URL
    mail(to: email, subject: "Next Steps")
  end

  def send_buyer_about_milestone(milestone,project,email)
    @milestone = milestone
    @project = project
    @login_link = SITE_LOGIN_URL
    mail(to: email, subject: "Milestones Ready for Payment")
  end

  def send_seller_about_milestone(milestone,project,email)
    @milestone = milestone
    @project = project
    @login_link = SITE_LOGIN_URL
    mail(to: email, subject: "Milestones Added for #{@project.full_title}")
  end

  def send_about_milestone_update(milestone,project,email)
    @milestone = milestone
    @project = project
    @login_link = SITE_LOGIN_URL
    mail(to: email, subject: "Milestones has been Updated")
  end

  def send_about_milestone_status(milestone,project,email)
    @milestone = milestone
    @project = project
    @login_link = SITE_LOGIN_URL
    mail(to: email, subject: "Milestones has been #{@milestone.status}")
  end

  def send_others_about_award(project, bid, user)
    @project = project
    @bid = bid
    @user = user
    @login_link = SITE_LOGIN_URL
    mail(to: @user.email, subject: "#{@project.full_title} was Awarded to Another #{DISPLAY_LABEL_SHORT}")
  end

  #send out once payment failed by buyer

  def notify_about_payment_fail(project, milestone)
    @user = project.buyer
    @project = project
    @milestone = milestone
    @login_link = SITE_LOGIN_URL
    @logo = SITE_LOGO
    mail(to: @user.email, subject: "Payment Failed")
  end

  #after project complete for feedback send this to buyer

  def request_for_review_buyer(project, project_url)
    @project = project
    @project_url = project_url
    @buyer = project.buyer
    @logo = SITE_LOGO
    @login_link = SITE_LOGIN_URL
    mail(to: @buyer.email, subject: "Rate your #{DISPLAY_LABEL_SHORT}")
  end

  #after project complete for feedback send this to seller

  def request_for_review_seller(project, project_url)
    @project = project
    @project_url = project_url
    @seller = project.seller
    @logo = SITE_LOGO
    @login_link = SITE_LOGIN_URL
    mail(to: @seller.email, subject: "Rate your #{BUYER_NAME_SHORT}")
  end

  # send this after feedback for buyer & seller

  # def feedback_thanks_seller(project)
  #   @project = project
  #   @project_url = project_url
  #   @seller = project.seller
  #   @buyer = project.buyer
  #   @logo = SITE_LOGO
  #   @login_link = SITE_LOGIN_URL
  #   mail(to: @seller.email, subject: "Feedback")
  # end

  def feedback_thanks_buyer(project)
    @project = project
    @project_url = project_url
    @seller = project.seller
    @buyer = project.buyer
    @logo = SITE_LOGO
    @login_link = SITE_LOGIN_URL
    mail(to: @buyer.email, subject: "Feedback")
  end

  def send_buyer_about_project_cancel
    @login_link = SITE_LOGIN_URL
  end

  def send_seller_about_project_cancel
    @login_link = SITE_LOGIN_URL
  end

  def notify_buyer_about_quotes_one_day(project)
    @project = project
    @buyer = project.buyer
    @logo = SITE_LOGO
    @login_link = SITE_LOGIN_URL
    mail(to: @buyer.email, subject: "#{@project.bids.count} Quotes. What Now?")
  end

  def notify_buyer_about_quotes_one_week(project)
    @project = project
    @buyer = project.buyer
    @logo = SITE_LOGO
    @login_link = SITE_LOGIN_URL
    mail(to: @buyer.email, subject: "What did you Decide?")
  end

  def ask_buyer_about_cancellation
    @login_link = SITE_LOGIN_URL
  end

  def send_guest_review_email(guest_user)
    @guest_user = guest_user
    @from_user = @guest_user.user
    @login_link = SITE_LOGIN_URL
    mail(to:  @guest_user.email, subject: "#{@from_user.full_name} has requested a review from you")
  end

  #Once buyer funded then send to seller this email
  def send_seller_funds_on_way(project, milestone)
    @logo = SITE_LOGO
    @project = project
    @seller = project.seller
    @milestone = milestone
    @delivery_date = user_time_zone(@seller, @milestone.delivery_date)
    @membership_plan_fee = @seller.membership_plan.service_fee.to_i
    @bed_fee =  @membership_plan_fee || AdminSetting.first.try(:bid_fee)
    @bed_fee = 5 unless @bed_fee
    @amount_earned  = milestone.price.to_f - (@bed_fee*milestone.price.to_f/100)
    @overhaul_fee = @bed_fee*milestone.price.to_f/100
    mail(to: @seller.email, subject: "Funds on the Way")
  end

  #once buyer funded then send to buyer this email

  def notify_about_payment_success(project, milestone)
    @login_link = SITE_LOGIN_URL
    @logo = SITE_LOGO
    @project = project
    @buyer = project.buyer
    @seller = project.seller
    @milestone = milestone
    mail(to: @buyer.email, subject: "Payment Received")
  end

  def send_inbox_message(message, sender, receiver)
    notify_emails = []
    @sender = sender
    @receiver = receiver
    @message = message
    if @receiver.seller?
      notify_emails = @receiver.notify_emails.split(',') if @receiver.notify_emails
      notify_emails.push(@receiver.email)
      notify_emails.each do |seller_email|
        mail(to: seller_email, subject: "#{@sender.visible_name} Sent you a Message").deliver!
      end
    else
      mail(to: @receiver.email, subject: "#{@sender.visible_name} Sent you a Message")
    end
  end

  #Send Emails To Admin start

  def notify_admin_send_inbox_message(message, sender, receiver)
    @sender = sender
    @receiver = receiver
    @message = message
    @admin_name = admin_name
    mail(to: admin_email, subject: "#{@sender.visible_name} Sent a Message")
  end

  def membership_upgraded(plan,user)
    @plan = plan
    @user = user
    mail(to: user.email, subject: "Your Membership plan has been upgraded to #{plan.name}")
  end

  def send_mail_about_rehiring(project)
    @project = project
    @hired_freelancer = @project.hired_freelancer
    mail(to: @hired_freelancer.email, subject: "You have been rehired for the project #{@project.full_title}")
  end

end