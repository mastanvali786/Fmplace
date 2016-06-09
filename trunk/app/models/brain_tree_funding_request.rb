class BrainTreeFundingRequest < MilestoneFundingRequest
	def invoice!(receiver, settings=nil)
		current_url =  settings[:current_url]
    	paypal_ipn_url = settings[:paypal_ipn_url]
      puts "self  funding_request",self.invoice
	    unless invoiced?
	    	invoice = BrainTreeInvoice.create!(
                       	funding_request:self,
                       	sender_id:self.sender.try(:id),
                        receiver_id:receiver.id,
                        amount: self.milestone.price
            )
        invoice
	    end
	end
end