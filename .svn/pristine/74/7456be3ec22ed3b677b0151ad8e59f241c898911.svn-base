ActiveAdmin.register AdminUser do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation
  menu :parent => "Other Settings"
  index :download_links => false do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions name:"Actions"
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Admin Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
  show do |admin_user|
    attributes_table do
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
      row :role_name
      row :lat
      row :lng
      row :video_url
      row :time_zone
      row :day_light_saving
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
    end
  end
end
