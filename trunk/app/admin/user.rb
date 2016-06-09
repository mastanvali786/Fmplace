ActiveAdmin.register User do


  filter :first_name_cont, label: 'First Name'
  filter :last_name_cont, label: 'Last Name'
  filter :phone_cont, label: 'Phone Number'
  filter :email_cont, label: 'Email'
  config.batch_actions = false;
  permit_params :first_name, :last_name, :email, :password, :password_confirmation,
  :profile_photo,:phone, :display_name, :address, :video_url, :time_zone,
  :is_active
  menu :parent => "Users", :label => 'All Users'
  actions  :index,:edit,:show,:update
  scope :all, :default => true
  scope :clients      #scope :buyers,
  scope :freelancers  #scope :sellers 
  form do |f|
    f.inputs "User" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
      f.input :address
      f.input :profile_photo
      f.input :video_url
      f.input :time_zone
      f.actions
    end
  end

  index do
    id_column
    column :full_name
    column :email
    column :phone
    column :is_active
    column :actions do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to "Switch User", switch_account_admin_user_path(resource), :method => :get, :class => "member_link"
      links += link_to "Make #{!resource.is_active ? 'Activate' : 'Deactivate'}", make_active_inactive_admin_user_path(resource), :method => :put, :class => "member_link"
      links
    end
  end

  show  title:"User" do |user|
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :phone
      row :display_name
      row :address
      row :country_name
      row :state_name
      row :city
      row :zipcode
      if user.seller?
      row 'role_name' do |u|
        "Freelancers"
      end
      else
        row 'role_name' do |u|
        "Clients"
      end
      end
      row :approved
      row :is_active
      row :lat
      row :lng
      row :video_url
      row :time_zone
      row :day_light_saving
      if user.seller?
        row 'Biography' do |u|
          u.user_biography.try(:summary) if u.user_biography.present?
        end
        row "Skills" do |u|
          get_name_by_ids(SkillTag,u.user_skill.try(:known_skills)).split(',').join(', ') if u.user_skill.present?
        end
      end
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
    end
  end

  member_action :make_active_inactive, :method => :put do
    user = User.find(params[:id])
    if user.is_active
      user.update_attribute(:is_active,false)
      flash[:notice] = "User deactivated."
    else
      user.update_attribute(:is_active,true)
      flash[:notice] = "User activated."
    end
    redirect_to :back
  end

  member_action :switch_account, :method => :get do
    session[:admin_login] = true
    sign_in(:user, User.find(params[:id]), { :bypass => true })
    redirect_to projects_path
  end

  csv do
   column " FUll Name" do |u|
     u.full_name 
   end	
   column "Email" do |u|
    u.email
  end	
  column "Phone Number" do |u|
    u.phone
  end
  column "Active " do |u|
    u.is_active
  end
  column "Address " do |u|
    u.address
  end
  # column "Roll Id " do |u|
  #   u.role_id
  # end
  # column :phone	
  # column :display_name	
  # column :country_id	
  # column :state_id	
  # column :zipcode	
  # column :city	
  # column :address
  # column :role_id
    # column :profile_photo
    # column :video_url	
    # column :time_zone	
    # column :lat
    # column :lng
    # column :currency	
    # column :business_started
    # column :category_ids
    # column :notify_category
    # column :day_light_saving
    # column :tagline
    # column :hourly_rate
    # column :summary
    # column :detail_info
    # column :skill_ids
    # column :notify_skill
    # column :notify_emails
    # column :approved
    # column :visible	
    # column :email	
    # column :reset_password_sent_at
    # column :remember_created_at
    # column :sign_in_count
    # column :current_sign_in_at
    # column :last_sign_in_at
    # column :current_sign_in_ip
    # column :last_sign_in_ip
    # column :confirmed_at
    # column :confirmation_sent_at
    # column :created_at	
    # column :updated_at	
    # column :is_active	
    # column :braintree_customer_id
    # column :priority
    # column :membership_renewal
    # column :user_id
    # column :ref_id
    # column :total_connects
    # column :used_connects
    # column :bonus_connects
    # column :search_priority	
    # column :referral_bonus	
    # column :referral_amount	
    # column :referral_source	
  end
end
