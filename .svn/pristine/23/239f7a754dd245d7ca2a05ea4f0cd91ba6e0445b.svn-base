class UserSkill < ActiveRecord::Base

	# Association
	belongs_to :user

	# Array serialize
	serialize :known_skills, Array

	# Validates
	validates :known_skills, presence: true
end
