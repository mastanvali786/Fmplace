ActiveAdmin.register ThemeSetting do

  menu :parent => "Theme Settings",:lebel=> 'Themes'
  config.filters = false
  config.batch_actions = false

  actions :all, :except => [:new, :create, :show, :destroy]

  permit_params :theme_id, :logo

  breadcrumb do
    [
      
    #   link_to('Theme Settings', admin_theme_settings_path),
    ]   
  end

  controller do
    def index
      redirect_to edit_admin_theme_setting_path(1)
    end
  end

  form  html: {:multipart => true} do |f|
    f.inputs "Logo" do 
      f.input :logo, :as => :file, :hint => f.object.logo.present? \
    ? image_tag(f.object.logo.url(:thumb))
    : content_tag(:span, "No Logo updated")
    end
    f.inputs "Change Theme" do
      f.input :theme_id , :label => 'Theme', :as => :select , :collection => Theme.all.map{|u| [u.name, u.id]}, :prompt => "-Select Theme-"
    end
    f.actions
  end

end
