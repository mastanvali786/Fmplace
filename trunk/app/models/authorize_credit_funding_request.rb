class AuthorizeCreditFundingRequest < MilestoneFundingRequest
	def invoice!(receiver, settings=nil)
		current_url =  settings[:current_url]
    	paypal_ipn_url = settings[:paypal_ipn_url]
	    unless invoiced?
        invoice_id = self.id
        unique_number = SecureRandom.hex 16
        unique_invoice_id = "#{invoice_id}#{unique_number}"

        
        data = {
          invoiceId: unique_invoice_id
        }

	    	invoice = AuthorizeCreditInvoice.create!(
                       	funding_request:self,
                       	sender_id:self.sender.try(:id),
                        receiver_id:receiver.id,
                        amount: self.milestone.price,
                        data:data
            )
        invoice
	    end
	end
end