class Banner < ActiveRecord::Base

	mount_uploader :slider_image, BannerUploader


	validates :slider_image, presence: true
	validate :check_dimensions

	  def check_dimensions
	  	if image
	    	if (image['width'] < 500 || image['height'] < 200)
	     		errors.add :image, "Dimension too small."
	      		self.errors.add(:base, "Dimension too small.")
	    	end
	    end
	  end

	# Method to get Height and Width
	def image
	    @image ||= MiniMagick::Image.open(slider_image.path) if @image
	end

end
