ActiveAdmin.register BudgetOption do

  menu :parent => "Project Module"
  
  permit_params :id , :name, :project_budget_id
  config.batch_actions = false
  filter :name_cont, label: 'Budget Cost Name'
  filter :project_budget, label: 'Budget Cost Type', :collection => proc {(ProjectBudget.all).map{|c| [c.name, c.id]}}

  # removing delete option
  actions :all, :except => [:destroy]
 breadcrumb do 
  []
end
  index :download_links => false do
    
    column "Budget Cost Name" do |budget| 
      budget.name
    end
    column "Budget Cost Type" do|budget|
        budget.project_budget_name
    end
   actions name: "Actions"
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end


  form do |f|
    f.inputs "Topics for Non Compliance" do
      f.input :name 
      f.input :project_budget_id , :label => 'Category', :as => :select , :collection => ProjectBudget.all.map{|u| [u.name, u.id]}, :prompt => "-Select Category-"
    end
    f.actions
  end


end
