class DisputeController < ApplicationController

	def create
	  dispute = Dispute.new dispute_params
	  if dispute.save

 
      emailtemplate=EmailTemplate.find_by_template('dispute')
    subject=emailtemplate.subject % {subject: dispute.subject}
    body=emailtemplate.content % {admin_name: admin_name, user_id: dispute.user.id, full_name:dispute.user.full_name,project_id: dispute.project.id,full_title: dispute.project.full_title,body: dispute.body,site_url: SITE_URL,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    email_setting(current_user,subject,body,admin_email)
      

      #DisputeMailer.delay.send_dispute(dispute)
      flash[:notice] = "Dispute Reported to Site Admin Successfully."
    else
    	flash[:error] = "Failed To send Dispute. Please try again."
    end
    redirect_to :back
	end

  private

	def dispute_params
    params.require(:dispute).permit(:subject,:body,:user_id, :project_id)
  end
end
