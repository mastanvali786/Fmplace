ActiveAdmin.register EmailTemplate do

  menu :parent => "Email Management"

  permit_params :template, :content, :subject

  
  form do |f|
    f.inputs "Email templates" do
      f.input :subject, input_html: { rows: "1"}
      f.input :content, :as => :ckeditor
    end
    f.actions
  end

  index title: "Email templates" do
    selectable_column
    column :template
    column :subject
    actions name:"Actions"
  end

  show do |faq|
    attributes_table do
      row :template
      row :subject
      row "content" do |mail|
      mail.content.html_safe
      end
      
    end
  end

end