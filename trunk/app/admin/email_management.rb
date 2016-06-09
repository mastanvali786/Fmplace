ActiveAdmin.register EmailManagement do

  menu :parent => "Email Management",:label => "Email Management"
  permit_params :options, :api_user,:api_key,:is_active

  config.batch_actions = false
  form do |f|
    f.inputs "Email Management" do
      #f.input :options, :as => :radio, :collection => ["Customer.io", "send grid","local mail"]
      f.input :api_user
      f.input :api_key
    end
    f.actions
  end

  index title: "Email Management", :download_links =>false do
    column :options
    column :api_user
    column :api_key
    column :actions do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to "Make #{!resource.is_active ? 'Activate' : 'Deactivate'}", make_active_inactive_admin_email_management_path(resource), :method => :put, :class => "member_link"
      links
    end
  end
  member_action :make_active_inactive, :method => :put do
    email_manage = EmailManagement.find(params[:id])
    activecount=EmailManagement.where(:is_active=>1).count
    
    
    if email_manage.is_active
      email_manage.update_attribute(:is_active,false)
      flash[:notice] = "Email setting deactivated."
      
    else
      if activecount<1
        email_manage.update_attribute(:is_active,true)
        flash[:notice] = "Email setting activated."
      else
        flash[:notice] = "Sorry.Already one email setting is active."
      end

      
    end

    redirect_to :back
  end


end