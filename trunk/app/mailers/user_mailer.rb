class UserMailer < ActionMailer::Base
   include ApplicationHelper
  default from: MAILER_FROM

  def welcome_email(user)
    email_setting
    @user = user
    @url  = SITE_LOGIN_URL
    mail(to: @user.email, subject: 'Welcome to ReverseAuction')
  end

  def contact_email(user)
    email_setting
    @contact= user
    if user.email_copy
    	@recepients=[user.email, MAILER_FROM]
    else
    	@recepients= MAILER_FROM
    end
    mail(to: @recepients, subject: 'Contact us')
  end

  def send_membership_upgrade_mail(user)
    @user = user
    @plan = user.membership_plan
    @email = user.email
    mail(to: @email, subject: "Your Membership Plan is nearing to expiry date")
  end

  def send_about_membership_auto_renewal(user)
    @user = user
    mail(to: @user.email, subject: "Your Membership Plan has been autorenewed")
  end

  def send_about_membership_expiry(user)
    @user = user
    mail(to: @user.email, subject: "Your Membership Plan is nearing to expiry date")
  end

  def send_about_membership_degradation_renewal(user)
    @user = user
    mail(to: @user.email, subject: "Your Membership Plan has been expired and it degraded to  Basic Plan")
  end

end
