ActiveAdmin.register Project do

  menu :parent => "Project Module", label: "All Projects"
  actions  :index, :show, :destroy
  #menu :priority => 2
  #menu :label => "All Projects"
  # config.sort_order = id_asc
  scope :all, :default => true
  scope :opened
  scope :awarded
  scope :completed
  scope :closed
  #filters
  filter :title_cont, label: 'Project Name'
  filter :category, label: 'Category', :collection => proc {(Category.all).map{|c| [c.name, c.id]}}
  filter :subcategory, label: 'Subcategory', :collection => proc {(Subcategory.all).map{|c| [c.name, c.id]}}

  index do
    selectable_column
    id_column 
    column "End Date",:end_date
    column "Project Name" do |project|
      link_to project.full_title, '#', onclick: "project_details(#{project.id});"
    end
    column "Category",:category
    column "Status",:project_state
    column "Client Name",:buyer do |proj|
      link_to(proj.buyer.visible_name, admin_user_path(proj.buyer)) if proj.buyer
    end
    column "Amount",:amount do |project|
      div :class=>"align_field" do
        unless project.amount.nil?
          number_to_currency project.amount
        else
          '-------------'
        end
      end
    end
    column "Freelancer Name",:seller_shop do |shop|
      div :class=>"align_field" do
        unless shop.seller_shop.nil?
          link_to(shop.seller_shop, admin_user_path(shop.seller))
        else
          '-------------'
        end
      end
    end
    actions name:"Actions"
    div id: "dialog-message" do
    end
  end

  show do
    attributes_table do
      row "Project Posted By" do |project|
        link_to(project.user.visible_name, admin_user_path(project.user))
      end
      row :id
      row :full_title
      row :category_name
      row :subcategory_name
      row :tags
      row :skills
      row :budget
      row :estimated_time
      row :country_name
      row :state_name
      row :city
      row :zip_code
      row :description
      row :created_at
      row :end_date
    end
  end

  csv do
    column "Date" do |u|
      date_time u.end_date
    end
    column "Project Name" do |u|
      u.full_title
    end
    column "Category" do |u|
      u.category_name
    end
    column "Status" do |u|
      u.project_state
    end
    column "Client Name" do |u|
      u.buyer.try(:visible_name) if u.buyer.present?
    end
    column "Freelancer Name" do |p|
      unless p.seller_shop.nil?
        p.seller_shop
      else
        '-------------'
      end
    end
    column "Amount" do |a|
      unless a.amount.nil?
        number_to_currency a.amount
      else
        '-------------'
      end
      
    end
  end
  

  # Controller
  controller do 

    # Method to View Project in dashboard popup
    def view_project
      @project = Project.find(params[:id])
      render layout: false
    end
  end


end
