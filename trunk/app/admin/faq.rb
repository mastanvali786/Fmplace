ActiveAdmin.register Faq do

    menu :parent => "Terms and Conditions"

  permit_params :question, :answer
  config.batch_actions = false
  filter :question_cont, label: "Question"

  breadcrumb do
    [
      
      
    ]   
  end
  form do |f|
    f.inputs "Frequently Asked Questions" do
      f.input :question, input_html: { rows: "1"}
      f.input :answer, :as => :ckeditor
    end
    f.actions
  end

  index title: "Frequently Asked Questions" do
    column :question
    actions
  end

  show do |faq|
    attributes_table do
      row :question
      row "Answer" do
        raw faq.answer
      end
      row :created_at
      row :updated_at
    end
  end

end