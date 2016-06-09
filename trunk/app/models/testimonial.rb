class Testimonial < ActiveRecord::Base

	belongs_to :country

	mount_uploader :photo, AvatarUploader

	delegate :country_code, to: :country, prefix: true, allow_nil: true

	validates :name, presence: true
	validates :comment, presence: true
	validates :photo, presence: true
	validates :country_id, presence:true
end
