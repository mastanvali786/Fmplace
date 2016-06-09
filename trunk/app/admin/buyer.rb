ActiveAdmin.register Buyer do

  menu :parent => "Users",:label => "Clients"
  #scope :buyers, :default => true
  scope :clients, :default => true
  actions  :index
  config.batch_actions = false
  config.sort_order = "created_at_asc"
  filter :first_name_cont, label: 'First Name'
  filter :last_name_cont, label: 'Last Name'
  filter :phone_cont, label: 'Phone Number'
  filter :email_cont, label: 'Email'
  
  index title: "Clients" do
    id_column 
    column "Reg Date" do |user|
      date_time user.created_at
    end
    column "Client Name" do |user|
      link_to(user.visible_name, admin_user_path(user)) 
    end
    column "Email" do |user|
      user.email 
    end
    column "Project Posted" do |user|
      user.project_posted_bidded
    end
    column "Project Awarded" do |user|
      user.project_awarded
    end
    column "Project Ended" do |user|
      user.project_completed
    end
    column "Paid Amount" do |user|
      user.paid_amount
    end
    column "Pending Amount" do |user|
      user.pending_amount
    end
  end

  csv do
    column "Reg Date" do |u|
      date_time u.created_at
    end
     column "Client Name" do |u|
      u.visible_name
    end
     column "Project Posted" do |u|
      u.project_posted_bidded
    end
     column "Project Awarded" do |u|
      u.project_awarded
    end
     column "Project Ended" do |u|
      u.project_completed
    end
    column "Paid Amount" do |u|
      u.paid_amount
    end
    column "Pending Amount" do |u|
      u.pending_amount
    end
  end

end
