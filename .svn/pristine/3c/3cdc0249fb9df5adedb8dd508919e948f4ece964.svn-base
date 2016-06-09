ActiveAdmin.register Seller do
  
  menu :parent => "Users",:label => "Freelancers"
  #scope :sellers, :default => true
  config.batch_actions = false
  scope :freelancers, :default => true
  actions  :index

  filter :first_name_cont, label: 'First Name'
  filter :last_name_cont, label: 'Last Name'
  filter :phone_cont, label: 'Phone Number'
  filter :email_cont, label: 'Email'

  index title: "Freelancers" do
    column "Appr Date",:created_at
    column "Freelancer Name" do |user|
      link_to(user.visible_name, admin_user_path(user)) 
    end
    column "Email" do |user|
      user.email 
    end
    column "Project Bidded" do |user|
      user.project_posted_bidded
    end
    column :approved
    column "Current Project" do |user|
      user.project_awarded
    end
    column "Project Ended" do |user|
      user.project_completed
    end
    column "Total Earnings" do |user|
      user.paid_amount
    end
    column "Pending Amount" do |user|
      user.pending_amount
    end
    column "Plan" do |user|
      user.membership_plan_name
    end
  end

  csv do
    column "Appr Date" do |u|
      date_time u.created_at
    end
    column "Freelancer Name" do |u|
      u.visible_name
    end
    column "Project Bidded" do |u|
      u.project_posted_bidded
    end
    column "Current Project" do |u|
      u.project_awarded
    end
    column "Project Ended" do |u|
      u.project_completed
    end
    column "Total Earnings" do |u|
      u.paid_amount
    end
    column "Pending Amount" do |u|
      u.pending_amount
    end
  end

end
