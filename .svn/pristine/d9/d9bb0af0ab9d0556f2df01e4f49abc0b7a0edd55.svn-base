ActiveAdmin.register Banner do


  menu :parent => "Theme Settings", :label => "Banner Settings"
  config.batch_actions = false
  permit_params :slider_image

    index do
      column "Banner" do |banner|
        image_tag(banner.slider_image.url, style: "height: 100px;")
      end
      actions
    end

breadcrumb do
    [ ]   
  end
  form :html => { multipart: true } do |f|
    f.semantic_errors :base 
    f.inputs do
      f.input :slider_image, :as => :file, :hint => f.object.slider_image.present? \
    ? image_tag(f.object.slider_image.url(:thumb))
    : content_tag(:span, "No banner added")
    insert_tag(Arbre::HTML::Div) { content_tag(:span, "Height > 200px, Width > 500 px", style: "font-style: italic; margin: 274px;" )}
    end
    f.actions
  end

  show do
    attributes_table do
      row "Banner" do |image|
        image_tag(image.slider_image.url,  :style => "height: 100px;")
      end
      row :created_at
      row :updated_at
    end
  end

end