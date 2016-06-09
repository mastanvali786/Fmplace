ActiveAdmin.register SkillTag do

  menu :parent => "Project Module"

  permit_params :id , :name
   config.batch_actions = false
  filter :name_cont, label: 'Name'
  actions :all, :except => [:destroy]

  index :download_links => false do
    column :name
   actions name: "Actions"
  end

  show do
    attributes_table :name
  end

  form do |f|
    f.inputs "Topics for Non Compliance" do
      f.input :name
    end
    f.actions
  end

end
