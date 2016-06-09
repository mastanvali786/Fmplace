class UserDegree < ActiveRecord::Base

	# Associations
	has_many :user_educations
end
