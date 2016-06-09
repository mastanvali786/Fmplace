class MilestonePdf < Prawn::Document
	def initialize(project,milestones, view, logo)
   super(top_margin: 50)
   @project = project
   @milestones = milestones
   @view = view
    # Logo
    image logo
    project_details
    list_items
  end

  def project_details
    move_down 15
    text "Project Details", size: 15, style: :bold, align: :center
    move_down 15
    text "Project Start Date:  #{ @view.user_time_zone @project.created_at }"
    move_down 15
    text "Project Amount:  US $#{"%0.2f" % @project.amount}"
    move_down 15
    text "Status:  #{@project.project_state}"
    move_down 15
    text "Freelancer:  #{@project.seller_shop}"
    move_down 15
    text "Project End Date:  #{ @view.user_time_zone @project.end_date }"
    move_down 25
  end

  def list_items
    move_down 20
    text "Milestone Details", size: 15, style: :bold, align: :center
    move_down 15
    table item_header,:cell_style => {:overflow => :shrink_to_fit, :min_font_size => 5, :width => 100 } do
    end
    table item_rows,:cell_style => {:overflow => :shrink_to_fit, :min_font_size => 5, :width => 100 } do
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def item_header
    [ ["Milestone", "Notes", "Amount US $","Delivery Date", "Status"]]
  end

  def item_rows
    @milestones.map { |item| [item.description, item.note, "%0.2f" % item.price, @view.user_time_zone(item.delivery_date), item.status.titleize] }
  end
end