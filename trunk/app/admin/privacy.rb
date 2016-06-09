ActiveAdmin.register Privacy do

  menu :parent => "Terms and Conditions", label: "Privacy"

  permit_params :title, :content

  actions :all, :except => [:new, :create, :show, :destroy]
 breadcrumb do
    [ ]   
  end
  form do |f|
    f.inputs do
      f.input :content, :as => :ckeditor
    end
    f.actions
  end

  controller do
    def index
      redirect_to edit_admin_privacy_path(1)
    end
  end

end
