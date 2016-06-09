class ReportMailer < ActionMailer::Base
  default from: MAILER_FROM
  include ApplicationHelper

  def send_violation_report(report)
    @report = report
    @url  = SITE_LOGIN_URL
    @admin_name = admin_name
    mail(to: admin_email, subject: REPORT_VIOLATION_SUBJECT)
  end
end
