ActiveAdmin.register BusinessType do

  menu :parent => "Project Module"
  permit_params :name
  config.batch_actions = false
    filter :name_cont, label: 'Name'
    actions :all, :except => [:destroy]
  breadcrumb do
    []
  end

  index :download_links => false do
    column :id
    column " Name" do |type|
      type.name
    end
    actions name: "Actions"
  end

end
