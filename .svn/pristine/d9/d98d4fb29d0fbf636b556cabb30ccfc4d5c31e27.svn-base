ActiveAdmin.register Subcategory do

	menu :parent => "Project Module"
	permit_params :name, :category_id
	# collection_action :reorder, :method => :post do 
	# end         
	config.batch_actions = false
	filter :name_cont, label: 'Name'
	actions :all, :except => [:destroy]
	filter :category, label: 'Category', :collection => proc {(Category.all).map{|c| [c.name, c.id]}}

  #Index action
  index :download_links => false do 
    selectable_column
  	column "Subcategory Name" do |subcat|
  		subcat.name
  	end
  	column "Category Name" do |subcat|
  		subcat.category.name
  	end
  	actions name: "Actions"
  end

   form do |f|
    f.inputs "New SubCategory" do
      f.input :category_id, :label => 'Category', :as => :select, :collection => Category.all, :prompt => "Select category"
      f.input :name
    end
    f.actions
  end

end
