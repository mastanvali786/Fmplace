class UserEducation < ActiveRecord::Base

	# Associations
	belongs_to :user
	belongs_to :user_degree

	# delegate
	delegate :name, to: :user_degree, prefix: true, allow_nil: true

	# Validation
	validates :college_name, presence: true
	validates :degree_id, presence: true
	validates :field_of_study, presence: true
end
