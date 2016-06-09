class ProjectMailer < ActionMailer::Base
  default from: MAILER_FROM
  include ApplicationHelper

  def project_notification(user,project)
  	@user = user
	@project = project
	@login_url = SITE_LOGIN_URL
    @url  = project.url
    mail(to: user.email, subject: 'A Client is Requesting a Quote')
  end
end
