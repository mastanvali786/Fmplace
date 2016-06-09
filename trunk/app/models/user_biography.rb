class UserBiography < ActiveRecord::Base

	# Associations
	belongs_to :user

	# validation
	validates :summary, presence: true
end
