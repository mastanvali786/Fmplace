class PaymentListPdf < Prawn::Document
	def initialize(milestones, user, view, logo)
    	super(top_margin: 50)
    		@milestones = milestones
    		@view = view
        @user = user
        # Logo
        image logo
    		list_items
  		end

  		def list_items
    		move_down 20
    		text "Payment List", size: 15, style: :bold, align: :left
    		move_down 15
        table item_header,:cell_style => {:overflow => :shrink_to_fit, :min_font_size => 5, :width => 100 } do
        end
    		table item_rows,:cell_style => {:overflow => :shrink_to_fit, :min_font_size => 5, :width => 100 } do
      		self.row_colors = ["DDDDDD", "FFFFFF"]
      		self.header = true
    	end
  	end

    def item_header
      if @user.buyer?
        [ ["Received", "Project - Freelancer", "Milestone","Status", "Amount $"]]
      else
        [ ["Received", "Project - Client", "Milestone","Status", "Amount $"]]
      end
    end

  	def item_rows
      if @user.buyer?
        @milestones.map { |item| [ @view.user_time_zone(item.updated_at),item.project_shop,item.description,item.payment_status,"%0.2f" % item.price] }
      else
        @milestones.map { |item| [ @view.user_time_zone(item.updated_at),item.project_buyer,item.description,item.payment_status,"%0.2f" % item.price] }
      end
  	end
end