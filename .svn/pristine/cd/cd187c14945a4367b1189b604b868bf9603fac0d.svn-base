ActiveAdmin.register Terms  do
 
  menu :parent => "Terms and Conditions",label: "Terms and Conditions"
  actions :all, :except => [:new, :create, :show, :destroy]
  breadcrumb do
    [ ]   
  end

  permit_params :title, :subject

  form do |f|
    f.inputs do
      f.input :subject, :as => :ckeditor
    end
    f.actions
  end

  controller do
    def index
      redirect_to edit_admin_term_path(1)
    end
  end

end