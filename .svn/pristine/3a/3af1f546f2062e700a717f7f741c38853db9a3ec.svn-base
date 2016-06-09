ActiveAdmin.register PaymentSetting do

	menu false
	config.filters = false
	permit_params :payment_type_id, :key1, :value1, :key2, :value2, :key3, :value3,
	:key4, :value4, :key5, :value5, :key6, :value6, :key7, :value7, :key8, :value8, :key9, :value9

	controller do
		def edit
			@payment_setting = PaymentSetting.find(params[:id])
		end

		def update
			@payment_setting = PaymentSetting.find(params[:id])
			if @payment_setting.update_attributes(pay_settings_params)
				redirect_to admin_payment_types_path
			else
				render 'edit'
			end
		end

		private

		def pay_settings_params
			params.require(:payment_setting).permit(:key1, :value1, :key2, :value2, :key3, :value3,
	      :key4, :value4, :key5, :value5, :key6, :value6, :key7, :value7, :key8, :value8, :key9, :value9)
		end
	end

	form do |f|
		render "form"
	end
end
