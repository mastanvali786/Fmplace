class DisputeMailer < ActionMailer::Base
  default from: MAILER_FROM
  include ApplicationHelper

  def send_dispute(dispute)
    @dispute = dispute
    @url  = SITE_LOGIN_URL
    @admin_name = admin_name
    mail(to: admin_email, subject: "DISPUTE: #{@dispute.subject}")
  end

end
