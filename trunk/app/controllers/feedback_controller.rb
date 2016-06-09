class FeedbackController < ApplicationController
	
	def create
		project =  Project.find_by_id(params[:feedback][:project_id])
		if project.awarded?
			flash[:error] = "Once project is complete then you can submit feedback."
		else
			unless project.given_feedback?(current_user)
				feedback = Feedback.new feedback_params
				if feedback.save
					flash[:notice] = "Feedback Recorded Successfully."
					if current_user.buyer?
						
      emailtemplate=EmailTemplate.find_by_template('feedback')
    subject=emailtemplate.subject
    body=emailtemplate.content % {visible_name: project.buyer.visible_name, site_name: SITE_NAME,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    email_setting(current_user,subject,body,project.buyer.email)
					 # OverhaulMailer.delay.feedback_thanks_buyer(project)
			   	end
				else
					flash[:error] = "Failed To Recorde Feedback. Please try again."
				end
			else
				flash[:error] = "Feedback Already Recorded."
			end
		end
		redirect_to :back
	end

	private

	def feedback_params
		params.require(:feedback).permit(:from_id,:to_id, :project_id,
			:aggregate,:quality_work, :responsiveness,:professionalism,:expertise, :cost,
			:schedule,:comment, :project_id)
	end
end
