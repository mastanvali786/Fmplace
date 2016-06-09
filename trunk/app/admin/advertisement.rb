ActiveAdmin.register Advertisement do

   filter :user, label: 'Sections', :collection => proc {(AdSection.all).map{|c| [c.name, c.id]}}
   filter :campaign_name, label: 'Compaign Name', as: :select
   filter :ad_title, label: 'Ad Title', as: :select
   actions :all, :except => [:new, :create, :edit, :update]

   index do
    selectable_column
    column :campaign_name
    column :ad_title
    column :status
    column :no_of_clicks
    column :no_of_views
    column "User" do |ad|
        ad.user.first_name
    end
    column :admin_approved
        # actions
        column :actions do |resource|
          links = ''.html_safe
          links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
          # links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
          links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
          links += link_to "Make #{!resource.admin_approved ? 'active' : 'inactive'}", change_state_admin_advertisement_path(resource), :method => :put, :class => "member_link"
          links
      end
  end

  show do
    attributes_table do
        row :campaign_name
        row :ad_title
        row :status
        row :no_of_clicks
        row "budget_per_click" do |budget|
            "#{DEFAULT_CURRENCY}#{budget.budget_per_click}"
        end
        row "budget_per_day" do |budget|
            "#{DEFAULT_CURRENCY}#{budget.budget_per_day}"
        end
        row "Sections" do |ad|
            if ad.ad_sections_ids.present?
                ad.ad_sections_ids.split(",").map(&:to_i).each do |f|
                    section = AdSection.find_by_id(f)
                    section.name
                end
            else
                'All Pages'
            end
        end
        row "Visibility" do |ad|
            if ad.show_continuously == true
                "Show continuously"
            else
               "upto #{ad.stop_date}"
           end
       end
       row :no_of_views
       row "User" do |ad|
        ad.user.first_name
    end
    row "Total Allowed Clicks" do |ad|
        ad.paid_click_per_day
    end
    row "Total Used Clicks" do |ad|
        ad.ads_click_infos.where("created_at >= ?", Time.zone.now.beginning_of_day).count
    end
    row :created_at
    row :updated_at
end
end

member_action :change_state, :method => :put do
    user = Advertisement.find(params[:id])
    if user.admin_approved
      user.update_attribute(:admin_approved,0)
      flash[:notice] = "Disapproved Advertisement successfully"
  else
      user.update_attribute(:admin_approved,1)
      flash[:notice] = "Approved Advertisement successfully"
  end
  redirect_to :back
end
csv do 
    column "User" do |ad|
        ad.user.full_name
    end
    column "Campaign Name" do |u|
        u.campaign_name
    end
    column "Ad Title" do |u|
      u.ad_title
  end
  column "Status" do |u|
    u.status
end
  column "Ad Url" do |u|
    u.ad_url
    end
column "Ad Content" do |u|
    u.ad_content
end
column "Number Of Click" do |u|
    u.no_of_clicks
end
column "Number of Views" do |u|
    u.no_of_views
end

column "Budget Per Click" do |u|
    u.budget_per_day
end
column "Budget Per Day" do |u|
    u.budget_per_day
end
column "Show Continuously" do |u|
    u.show_continuously
end
column "Stop Date" do |u|
    u.stop_date
end
column "Days  Week" do |u|
    u.days_week
end
column "Status" do |u|
    u.status
end
column "Ad Section Id" do |u|
    u.ad_sections_ids
end
column "Admin Approved" do |u|
    if u.admin_approved == true
        'Yes'
    else
        'No'
    end
end
end
end