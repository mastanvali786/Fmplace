class PasswordsController < Devise::PasswordsController

	def create
		self.resource = resource_class.send_reset_password_instructions(resource_params)
		yield resource if block_given?
		if successfully_sent?(resource)
			if params[:platform] == "mobileApp"
				render json: {result: true, msg: "You will receive an email with instructions on how to reset your password in a few minutes."}
			else
				respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
			end
		else
			if params[:platform] == "mobileApp"
				render json: {result: false, msg: "Email id is not registered with us."}
			else
				respond_with(resource)
			end
		end
	end
end