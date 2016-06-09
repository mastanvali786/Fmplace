
ActiveAdmin.register Testimonial do

  menu :parent => "Theme Settings", :label => "Testimonial"

  permit_params :id , :name, :country_id, :comment, :photo

  form :html => { multipart: true } do |f|
    render "form"
  end
breadcrumb do
    [ ]   
  end

  index do
    selectable_column
    column :name
    column :country_country_code
    actions name: "Actions"
  end

  show do
    attributes_table do
      row :name
      row :country_country_code
      row :comment
      row "Photo" do |image|
        image_tag(image.photo.url,  :style => "height: 100px;")
      end
      row :created_at
      row :updated_at
    end
  end

  controller do

  	def new
  		@testimonial = Testimonial.new
  	end

  	def create
  		@testimonial = Testimonial.new(testimonial_params)
  		if @testimonial.save
  			redirect_to admin_testimonials_path
  		else
  			render 'new'
  		end
  	end

    def edit
      @testimonial = Testimonial.find(params[:id])
    end

    def update
      @testimonial = Testimonial.find(params[:id])
      if @testimonial.update_attributes(testimonial_params)
        redirect_to admin_testimonials_path
      else
        render 'edit'
      end
    end

    private

    def testimonial_params
      params.require(:testimonial).permit(:name, :country_id ,:comment, :photo)
    end

  end

end
