ActiveAdmin.register Milestone do

  menu :parent => "Project Module", label: "All Milestones"
  actions  :index, :show, :destroy
  scope :accepted, :default => true
  scope :pending
  # scope :rejected
  scope :funded


  filter :description_cont, label:"Milestone Name", as: :string
  filter :price, label:"Milestone Amount"
  filter :delivery_date, label:"Delivery Date"
  # filter :buyer, label: 'Client', :collection => proc {(User.buyers.all).map{|c| [c.first_name, c.id]}}
  # filter :seller, label: 'Freelancer', :collection => proc {(User.sellers.all).map{|c| [c.first_name, c.id]}}
  filter :project, label: 'Project', :collection => proc {(Project.all).map{|c| [c.title, c.id]}}
  # filter :delivery_date, label:"Delivery Date"
  # filter :price, label:"Milestone Amount", as: :select
  # filter :description, label:"Milestone Name", as: :select
  index do
    selectable_column
    id_column
    column "Created Date",:created_at
    column "Milestone Name",:description
    column "Note",:note
    column "Milestone Amount" do |mile|
      number_to_currency mile.price
    end
    column "Delivery Date",:delivery_date
    column "Project Name" do |mile|
      link_to mile.project.full_title, '#', onclick: "project_details(#{mile.project.id});"
    end
    # column "Buyer Name"do |mile|
    #   link_to(mile.buyer.visible_name, admin_user_path(mile.buyer)) 
    # end
    # column "Seller Name" do |mile|
    #   link_to(mile.seller.visible_name, admin_user_path(mile.seller))
    # end
    column "Payment Status" do |mile|
      unless  mile.status == 'rejected'
        mile.payment_status
      end
    end
    div id: "dialog-message" do
    end
    actions name:"Actions"
  end

  show do |mile|
    attributes_table do
      row :id
      row :created_at
      row :description
      row :note
      row :status
      row "Milestone Amount" do |mile|
        number_to_currency mile.price
      end
      row "Delivery Date" do |mile|
        mile.delivery_date
      end
      row "Project Name" do |mile|
        link_to mile.project.full_title, '#', onclick: "project_details(#{mile.project.id});"
      end
      row "Client Name"do |mile|
        link_to(mile.buyer.visible_name, admin_user_path(mile.buyer)) 
      end
      row "Freelancer Name" do |mile|
        link_to(mile.seller.visible_name, admin_user_path(mile.seller))
      end
      row "Payment Status" do |mile|
        mile.payment_status
      end
      div id: "dialog-message" do
      end
    end
  end

  csv do
    column "Created Date" do |milestone|
      date_time milestone.created_at
    end
     column "Milestone Name" do |milestone|
      milestone.description
    end
    column "Note" do |milestone|
      milestone.note
    end
     column "Milestone Amount" do |milestone|
      number_to_currency milestone.price
    end
    column "Delivery Date" do |milestone|
      date_time milestone.delivery_date
    end
     column "Project Name" do |milestone|
      milestone.project.try(:full_title)
    end
    column "Client Name" do |milestone|
      milestone.buyer.try(:full_name)
    end
    column "Freelancer Name" do |milestone|
      milestone.seller.try(:full_name)
    end
    column "Payment Status" do |milestone|
      milestone.payment_status
    end
  end

end
