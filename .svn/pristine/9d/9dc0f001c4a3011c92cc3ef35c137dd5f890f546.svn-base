ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  content title: proc{ I18n.t("active_admin.dashboard") } do
  columns do
    column do
      panel "Projects Posted" do
        Project.all.count
      end
    end

  column do
    panel "Projects Completed" do
      project_status = Project.all.map(&:current_state)
      project_status.flatten.count("completed") if project_status
    end
  end
  column do
    panel "Total Bids" do
      Bid.all.count
      # count = 0
      # Project.all.each do |p|
      #   count = count + p.bids.count
      # end
      # count
    end
  end
  column do
    panel "Registered Clients" do
      User.buyers.count if User.buyers.present?
    end
  end
  column do
    panel "Approved Freelancers" do
      User.approved_shops.count
    end
  end
  column do
    panel "Pending Approvals" do
      User.pending_shops.count
    end
    div class:'btn', style: "float: right;" do
      link_to "Click here to approve freelancers",  admin_approve_shops_path
    end
  end
end
columns do
  render "admin/dashboard/dashboard"
  end
end

end