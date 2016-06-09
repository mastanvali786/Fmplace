ActiveAdmin.register ApproveShop do
  menu :label => "Approve Freelancers"
  scope :sellers, :default => true
  actions  :index, :show, :update

  filter :first_name_cont, label: 'First Name'
  filter :last_name_cont, label: 'Last Name'
  filter :phone_cont, label: 'Phone Number'
  filter :email_cont, label: 'Email'

  
  #filter :created_at, :label => 'From Date'
  form do |f|
    f.inputs "Approve Freelancers" do
      f.input :first_name
      f.input :phone
      f.input :display_name
      f.input :approved

      f.actions
    end
  end
  index :title => "Approve Freelancers" do
    selectable_column
    id_column
    column :created_at
    column :full_name
    column :phone
    column :email
    column "Freelancer Display Name" do |user|
      link_to(user.visible_name, admin_user_path(user))
    end
    column "Plan" do |user|
      user.membership_plan_name
    end
    column :approved
    column :actions do |resource|
      links = ''.html_safe
      # links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      # links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      #links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      links += link_to "Make #{!resource.approved ? 'active' : 'inactive'}", change_state_admin_approve_shop_path(resource), :method => :put, :class => "member_link"
      links
    end
  end
  

  # custom action


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :first_name, :phone, :display_name,:approved

  member_action :change_state, :method => :put do
    user = User.find(params[:id])
    if user.approved
      user.update_attribute(:approved,0)
      flash[:notice] = "Disapproved freelancer successfully"
    else
      user.update_attribute(:approved,1)
      flash[:notice] = "Approved freelancer successfully"
    end
    redirect_to :back
  end
  csv do
    column "Full Name"do |u|
      u.full_name
    end
    column "Phone Number"do |u|
      u.phone
    end
    column "Email"do |u|
      u.email
    end
    column "Freelancer Display Name"do |u|
      u.display_name
    end
    column "Plan" do |u|
      u.membership_plan_name
    end
    column "Approved" do |u|
      u.approved
    end
  end
end
