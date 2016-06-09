class GuestUserController < ApplicationController

	def create
	  guest = GuestUser.find_by_email(params[:guest_user][:email])
	  if guest
	    guest.update_attributes(guest_user_params)
	    send_mail_about_milestone_update(guest)
	    flash[:notice] = "Review request has been successfully sent."
	  else
      guest_user = GuestUser.new(guest_user_params)
	    if guest_user.save
	    	send_mail_about_milestone_update(guest_user)
	   	  flash[:notice] = "Review request has been successfully sent."
	    else
	   	  flash[:error] = "Failed review request to buyer. Please try after some time."
	    end
    end
    redirect_to :back
	end

	def send_mail_about_milestone_update(guest)
    guest_user = guest
      emailtemplate=EmailTemplate.find_by_template('guest_review_email')
    
    body=emailtemplate.content % {guest_user_name: guest_user.name, guest_user_message: guest_user.message,guest_user_id: guest_user.id, user_visible_name: guest_user.user.visible_name,site_url: SITE_URL,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
     subject=emailtemplate.subject % {full_name: guest_user.user.full_name}
    email_setting(current_user,subject,body,guest_user.email)
    #OverhaulMailer.delay.send_guest_review_email(guest_user)
  end

	def show
		@guest_user = GuestUser.find_by_id(params[:id])
		if @guest_user
			@user = @guest_user.user
			render 'show'
		else
			redirect_to root_path
		end
	end

	def record_feedback
		gu = GuestUser.find_by_id(params[:guest_user][:feedback][:guest_user_id])
		if gu
			gu.update_attributes(guest_user_params)
			feedback = Feedback.new feedback_params
			if feedback.save
				flash[:notice] = "Your Review has Submitted Successfully"
			else
				flash[:error] = "Please try after some time."
			end
		else
			flash[:error] = "Please try after some time."
		end
		redirect_to root_path
	end

	private
	def guest_user_params
		params.require(:guest_user).permit(:name,:email, :message,:user_id)
	end

	def feedback_params
		params.require(:guest_user).require(:feedback).permit(:guest_user_id,:to_id,
			:aggregate,:quality_work, :responsiveness,:professionalism,:expertise, :cost,
			:schedule,:comment)
	end

end
