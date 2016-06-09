class WebserviceController < ApplicationController

	def lock_website
		if params && params[:pass] == 'laxman!@'
			admin = AdminSetting.first
			admin.loading = false
			admin.save
	  end
		redirect_to root_path
	end

	def unlock_website
		if params && params[:pass] == 'laxman!@'
			admin = AdminSetting.first
			admin.loading = true
			admin.save
	  end
		redirect_to root_path
	end

end
