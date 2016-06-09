class TransactionPdf < Prawn::Document
	def initialize(transactions, user, view, logo)
    	super(top_margin: 50)
        @user = user
    		@transactions = transactions
    		@view = view
        # Logo
        image logo
    		list_items
  		end

  		def list_items
        text "Transaction History", size: 15, style: :bold, align: :left
        move_down 15
        text "Your most recent financial transactions are listed below.This is a record of all the credits and debits to your Account that have been processed to date"
        # move_down 15
        # text "Account Number: "
        move_down 15
        text "Available Balance: #{@view.number_to_currency(@user.balance.available)}"
        move_down 15
        text "Total Balance: #{@view.number_to_currency(@user.balance.total)}"
    		move_down 20
        table item_header,:cell_style => {:overflow => :shrink_to_fit, :min_font_size => 5, :width => 100 } do
        end
    		table item_rows,:cell_style => {:overflow => :shrink_to_fit, :min_font_size => 5, :width => 100 } do
      		self.row_colors = ["DDDDDD", "FFFFFF"]
      		self.header = true
    	end
  	end

    def item_header
      [ ["Date", "Type", "Amount", "Status", "Balance US $"]]
    end
    
  	def item_rows
  		@transactions.map  { |transaction| [ @view.user_date_zone(transaction.approvedOn), transaction.type.titleize , @view.number_to_currency(transaction.amount), transaction.status,@view.number_to_currency(transaction.balance)]}
  	end
end