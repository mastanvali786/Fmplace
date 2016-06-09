ActiveAdmin.register ContactEmail do

  menu :parent => "Users"
  config.batch_actions = false
  actions :all, :except => [:new, :edit]

  filter :name_cont, label: 'Name'
  filter :email_cont, label: 'Email'

  index :download_links => false do
  	column :name
  	column :email
  	column :email_copy
    actions name: "Actions"
    end

  show do
  	attributes_table do
      row :id
      row :name
      row :email
      row :subject
      row :message
      row :created_at
      row :updated_at
    end
  end

end
