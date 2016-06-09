require 'paypal-sdk-merchant'

module PayPalMerchantSdk
  def self.doMassPayment(request, invoice)
  	@api = PayPal::SDK::Merchant::API.new
  	# Build request object
		@mass_pay = @api.build_mass_pay({
		  :ReceiverType => "EmailAddress",
		  :MassPayItem => [{
		    :ReceiverEmail => request.user.paypal_email,
		    :Amount => {
		      :currencyID => "USD",
		      :value => invoice.amount } }] })

		# Make API call & get response
		@mass_pay_response = @api.mass_pay(@mass_pay)

		# Access Response
		if @mass_pay_response.success?
		else
		  @mass_pay_response.Errors
		end
  end

end