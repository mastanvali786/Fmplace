class ThemeSetting < ActiveRecord::Base

	mount_uploader :logo, LogoUploader

	belongs_to :theme

	# validates :logo, presence: true

end
